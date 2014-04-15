package nx3.io;

import nx3.ENoteVal;
import nx3.ESign;
import nx3.io.BarParser;
import nx3.io.QuickSyntax;
import nx3.io.QuickSyntax.ContentMode;
import nx3.io.ModeParser;
import nx3.io.NoteParser;
import nx3.NHead;
import nx3.NNote;
using StringTools;
/**
 * ...
 * @author Jonas Nyström
 */
class QuickSyntax
{
	var str:String;
	var tokens:Array<String>;
	var notes:Map<BPVIndex, Array<NNote>>;
	var barIndex:Int;
	var partIndex:Int;
	var voiceIndex:Int;
	
	var modefunctions:Map < String, Void->Void > ;
	var contentmodeOctave:Int;
	var contentmode:ContentMode;
	
	var notefunctions:Map < String, String->String> ;
	
	var notelevels:Array<Int>;
	var notevalue:ENoteVal;
	var notesigns:Array<ESign>;
	
	var nnotes:Array<NNote>;
	var modeparser:ModeParser;
	var barparser:BarParser;
	var noteparser:NoteParser;
	
	
	public function new(str:String) 
	{
		this.str = str.trim().replace('  ', ' ').replace('  ', ' ').replace('  ', ' ');
		this.tokens = parseTokens(this.str);
		this.modefunctions = new Map < String, Void->Void> ();
		this.notefunctions= new Map < String, String->String> ();
		
		this.barIndex = 0;
		this.partIndex = 0;
		this.voiceIndex = 0;
			
		this.notelevels = [];
		this.notesigns = [];
		this.notevalue = ENoteVal.Nv4;
		
		this.contentmodeOctave = 0;
		this.contentmode = ContentMode.Notes(contentmodeOctave);

		this.nnotes = [];
		this.modeparser = new ModeParser(this);
		this.barparser = new BarParser(this);
		this.noteparser = new NoteParser(this);
		
	}
	
	public function parse1()
	{
		for (token in this.tokens)
		{
			var testtoken = token;			
			trace('NEW TOKEN: $token');
			testtoken = this.modeparser.parse(token, this);
			if (testtoken == '') continue;

			testtoken = this.barparser.parse(token, this);
			if (testtoken == '') continue;			
			
			testtoken = this.noteparser.parse(token, this);
			if (testtoken == '') continue;
			
		}
		
		return null;
	}
	
	function parseTokens(str:String) :Array<String>
	{
		var result:Array<String> = [];
		result = str.split(' ');
		return result;
	}
	
}

typedef BPVIndex = { barIndex:Int, partIndex:Int, voiceIndex:Int };

enum ContentMode 
{
	Notes(octave:Int);
	Tpls;
	Lyrics;
}







