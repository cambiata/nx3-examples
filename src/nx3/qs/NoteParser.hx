package nx3.qs;
import cx.ArrayTools;
import nx3.ENoteVal;
import nx3.ESign;
import nx3.NHead;
import nx3.NNote;
using StringTools;
using cx.ArrayTools;
/**
 * ...
 * @author Jonas Nyström
 */
class NoteParser extends BaseParser
{
	var notelevels:Array<Int>;
	var notevalue:ENoteVal;
	var notesigns:Array<ESign>;	
	var prevlevels:Array<Int>;
	var prevvalue:ENoteVal;
	var prevsigns:Array<ESign>;		
	
	var clefAdjust:Int;
	var octAdjust: Int;
	
	
	public function new(parser:QuickSyntaxParser)
	{
		super(parser);

		this.notelevels = [];
		this.notesigns = [];
		this.notevalue = null;
		
		this.prevlevels = [0];
		this.prevsigns = [ESign.None];
		this.prevvalue = ENoteVal.Nv4;
		
		this.clefAdjust = 0;
		this.octAdjust = 0;
	}
	
	override public function createFunctions()
	{
		this.functions.set('c#', function (token:String) { this.notelevels.push(6); this.notesigns.push(ESign.Sharp); return token.substr(2); });
		this.functions.set('cB', function (token:String) {	this.notelevels.push(6);	this.notesigns.push(ESign.Flat);	return token.substr(2);});
		this.functions.set('cN', function (token:String) {	this.notelevels.push(6);	this.notesigns.push(ESign.Natural);	return token.substr(2);});
		this.functions.set('c', function (token:String) {	this.notelevels.push(6);this.notesigns.push(ESign.None);	return token.substr(1);});		

		this.functions.set('d#', function (token:String) {	this.notelevels.push(5);	this.notesigns.push(ESign.Sharp);	return token.substr(2);});
		this.functions.set('dB', function (token:String) {	this.notelevels.push(5);	this.notesigns.push(ESign.Flat);	return token.substr(2);});
		this.functions.set('dN', function (token:String) {	this.notelevels.push(5);	this.notesigns.push(ESign.Natural);	return token.substr(2);});
		this.functions.set('d', function (token:String) {	this.notelevels.push(5);	this.notesigns.push(ESign.None);	return token.substr(1);});		
		
		this.functions.set('e#', function (token:String) {	this.notelevels.push(4);	this.notesigns.push(ESign.Sharp);	return token.substr(2);});
		this.functions.set('eB', function (token:String) {	this.notelevels.push(4);	this.notesigns.push(ESign.Flat);	return token.substr(2);});
		this.functions.set('eN', function (token:String) {	this.notelevels.push(4);	this.notesigns.push(ESign.Natural);	return token.substr(2);});
		this.functions.set('e', function (token:String) {	this.notelevels.push(4);	this.notesigns.push(ESign.None);	return token.substr(1);});			
		
		this.functions.set('f#', function (token:String) {this.notelevels.push(3);	this.notesigns.push(ESign.Sharp);	return token.substr(2);});
		this.functions.set('fB', function (token:String) {	this.notelevels.push(3);	this.notesigns.push(ESign.Flat);	return token.substr(2);});
		this.functions.set('fN', function (token:String) {	this.notelevels.push(3);	this.notesigns.push(ESign.Natural);	return token.substr(2);});
		this.functions.set('f', function (token:String) {	this.notelevels.push(3);	this.notesigns.push(ESign.None);	return token.substr(1);});			
		
		this.functions.set('g#', function (token:String) { this.notelevels.push(2);	this.notesigns.push(ESign.Sharp);return token.substr(2);	});
		this.functions.set('gB', function (token:String) {	this.notelevels.push(2);	this.notesigns.push(ESign.Flat);	return token.substr(2);});
		this.functions.set('gN', function (token:String) {this.notelevels.push(2);	this.notesigns.push(ESign.Natural);	return token.substr(2);});
		this.functions.set('g', function (token:String) {	this.notelevels.push(2);	this.notesigns.push(ESign.None);	return token.substr(1);});			
		
		this.functions.set('a#', function (token:String) {	this.notelevels.push(1);	this.notesigns.push(ESign.Sharp);	return token.substr(2);});
		this.functions.set('aB', function (token:String) {	this.notelevels.push(1);	this.notesigns.push(ESign.Flat);	return token.substr(2);});
		this.functions.set('aN', function (token:String) {	this.notelevels.push(1);	this.notesigns.push(ESign.Natural);	return token.substr(2);});
		this.functions.set('a', function (token:String) {	this.notelevels.push(1);	this.notesigns.push(ESign.None);	return token.substr(1);});			
		
		this.functions.set('b#', function (token:String) {	this.notelevels.push(0);	this.notesigns.push(ESign.Sharp);	return token.substr(2);});
		this.functions.set('bB', function (token:String) {	this.notelevels.push(0);	this.notesigns.push(ESign.Flat);	return token.substr(2);});
		this.functions.set('bN', function (token:String) {	this.notelevels.push(0);	this.notesigns.push(ESign.Natural);	return token.substr(2);});
		this.functions.set('b', function (token:String) {	this.notelevels.push(0);	this.notesigns.push(ESign.None);	return token.substr(1);});			
		
		this.functions.set('2.', function (token:String) {	this.notevalue = ENoteVal.Nv2dot;	return token.substr(2);});		
		this.functions.set('2', function (token:String) {	this.notevalue = ENoteVal.Nv2;	return token.substr(1);});		
		this.functions.set('4.', function (token:String) {	this.notevalue = ENoteVal.Nv4dot;	return token.substr(2);});		
		this.functions.set('4', function (token:String) {	this.notevalue = ENoteVal.Nv4;	return token.substr(1);});
		this.functions.set('8.', function (token:String) {	this.notevalue = ENoteVal.Nv8dot;	return token.substr(2);});		
		this.functions.set('8', function (token:String) {	this.notevalue = ENoteVal.Nv8;	return token.substr(1);});		
		this.functions.set('16.', function (token:String) {	this.notevalue = ENoteVal.Nv16dot;	return token.substr(3);});		
		this.functions.set('16', function (token:String) {	this.notevalue = ENoteVal.Nv16;	return token.substr(2);});		
		
		this.functions.set('=', function (token:String) {	this.octAdjust = 0;	return token.substr(1);});		
		this.functions.set('+', function (token:String) {	this.octAdjust = -7;	return token.substr(1);});		
		this.functions.set('++', function (token:String) {	this.octAdjust = -14;	return token.substr(1);});		
		this.functions.set('-', function (token:String) {	this.octAdjust = 7;	return token.substr(1);});		
		this.functions.set('--', function (token:String) {	this.octAdjust = 14;	return token.substr(1);});		
	}	

	override private function tokenFinished(originaltoken:String) 
	{
		if (Lambda.has(['+', '++', '-', '--', '='], originaltoken)) return;
		
		if (this.notelevels.length < 1) this.notelevels = this.prevlevels.copy();
		if (this.notesigns.length < 1)  this.notesigns = this.prevsigns.copy();
		if (this.notevalue == null) this.notevalue = this.prevvalue;

		var val = this.notevalue;
		var nheads:Array<NHead> = [];
		for (i in 0...this.notelevels.length)
		{
			var level = this.notelevels[i] + this.octAdjust + this.clefAdjust;
			var sign = this.notesigns[i];
			nheads.push(new NHead(level, sign));
		}
		var nnote = new NNote(nheads, val);
		this.builder.addNote(nnote);
		this.prevlevels = this.notelevels.copy();
		this.prevsigns = this.notesigns.copy();
		this.prevvalue = this.notevalue;
		
		this.notelevels = [];
		this.notesigns = [];
		this.notevalue = null;
	}
	
	override public function recieveEvent(event:ParserEvents) 
	{
		trace('RECIEVED EVENT by NoteParser ' + event);
	}
	
	
	
}