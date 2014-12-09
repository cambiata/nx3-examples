package nx3.audio;
import cx.ArrayTools;
import haxe.macro.Expr.Position;
import nx3.audio.NotenrPartsCalculator.PartNotesToNotenrCalculator;
import nx3.EKeysTools;
import nx3.NHead;
import nx3.NNote;
import nx3.NPart;
import nx3.NParts;
import nx3.NScore;
import nx3.EClef;
import nx3.EKey;
import nx3.NVoice;
import nx3.QNote.QLyric8;
import nx3.QNote.QNote2;
import nx3.QNote.QNote4;
import nx3.QNote.QNote8;
import thx.core.Arrays;

using cx.ArrayTools;
using Lambda;
/**
 * NoteMidinrCalculator
 * @author 
 */
class NotenrPartsCalculator 
{
	var parts:NParts;
	var partvalues:Array<Int>;

	public function new(rowOfParts:nx3.NParts, partvalues:Array<Int>=null)  {
		//rowOfParts = NotenrTestItems.testTies();
		this.parts = rowOfParts;
		this.partvalues = partvalues;	
	}
	
	public function execute():Array<NotenrItem> {
		var partsItems = [];
		var currentclef:nx3.EClef = null;
		var currentkey:nx3.EKey = null;
		
		var prevpart: NPart = null;
		var prevnoteitems: Array<NotenrItem> = null;
		var resultnoteitems: Array<NotenrItem> = [];
		var partposition = 0;
		var partidx = 0;
		
		for (part in this.parts) {
			if (part.clef != null) currentclef = part.clef;
			if (part.key != null) currentkey = part.key;
			var noteitems = new PartNotesToNotenrCalculator(part, currentclef, currentkey).getNotnrItems();
			
			var partvalue = this.partvalues.indexOrNull(partidx);
			if (partvalue == null) {
				partvalue = 0;
				Lambda.iter(noteitems, function(item) { partvalue = Std.int(Math.max(partvalue, item.position + item.noteval)); } );
			}
			
			var tieditems1 = handleTiesInsidePart(noteitems);
			var tieditems2 = handleTiesBetweenParts(tieditems1, prevnoteitems);
			Lambda.iter(tieditems2, function(item) { item.partposition = partposition; } );
			partposition += partvalue;
			resultnoteitems = resultnoteitems.concat(tieditems2);
			prevnoteitems = tieditems2;
			partidx++;
		}
		//Lambda.iter(resultnoteitems, function(item) trace(item));
		return resultnoteitems;
	}
	
	function handleTiesBetweenParts(items:Array<NotenrItem>,previtems:Array<NotenrItem>) 
	{
		if (previtems == null ) return items;
		if (previtems.length == 0) return items;

		var ties:Array<TieFound> = [];
		var lastvalue = 0;
		Lambda.iter(previtems, function(item) { lastvalue = Std.int(Math.max(lastvalue, item.position + item.noteval)); } );
		var prevItems = Lambda.filter(previtems, function(item) { return (item.position + item.noteval == lastvalue) && item.tie == true; } );
		var firstItems = Lambda.filter(items, function(item) { return (item.position == 0); } );
		
		var itemscopy = Lambda.array(items);
		
		var validitems = [];
		for (previtem in prevItems) {
			var targetItem = Lambda.find(firstItems, function(firstitem) { 
				if (firstitem.level == previtem.level && firstitem.headsign == ESign.None) return true;
				return false;
			});
			
			if (targetItem != null) {
				//trace('previtem pre ' + previtem);
				previtem.noteval = previtem.noteval + targetItem.noteval;
				//trace('previtem post ' + previtem);
			}
			itemscopy.remove(targetItem);
		}
		return itemscopy;
	}
	
	private function handleTiesInsidePart(items:Array<NotenrItem>)
	{		
		var ties:Array<TieFound> = [];
		var validTies : Array<TieFound> = [];
		for (item in items)
		{
			if (item.tie == true) {
				var tie:TieFound = { position:item.position, notenr:item.notenr, noteval:item.noteval, targetpos:item.position + item.noteval, level:item.level, item:item, targetItem:null };
				if (item != items.last()) 
					ties.push(tie);
			}
		}
		for (tie in ties) {
			var targetItem = Lambda.find(items, function(titem:NotenrItem) {
				if (tie.targetpos == titem.position && tie.item.notenr == titem.notenr) {
					return true;
				}
				return false;
			});
			if (targetItem != null) {
				tie.targetItem = targetItem;
				validTies.push(tie);
			}
		}
		validTies.sort(function(a, b) { return Reflect.compare(a.position, b.position); } );
		validTies = cx.ArrayTools.reverse(validTies);

		var items2 = Lambda.array(items);
		for (tie in validTies) {
			var item:NotenrItem = tie.item;
			var targetItem = tie.targetItem;
			item.noteval = item.noteval + targetItem.noteval;
			items2.remove(targetItem);
		}
		
		return items2;
	}

	
	
	
	private function handleTiesParts(partitems:Array<Array<NotenrItem>>)
	{

		var tiefoundInside:Array<TieFound> = [];
		var tiefoundLast:Array<TieFound> = [];		
		
		// find ties
		for (items in partitems)
		{
			

			
			
			// ties from previous bar
			for (tiefound in tiefoundLast)
			{
				/*
				trace('SEARCH FOR ' + tiefound.targetpos + ' ' + tiefound.notenr);
				for (item in items)
				{
					if (item.position == tiefound.targetpos && item.level == tiefound.level) {
						trace('FOUND pos and level');
					}
				}
				*/
			}
			tiefoundLast = [];
			
			
			
			for (item in items)
			{
				if (item.tie == true) {
					trace( 'Found TIE ' + item);
					var tiefound:TieFound = { position:item.position, notenr:item.notenr, noteval:item.noteval, targetpos:item.position + item.noteval, level:item.level, item:item, targetItem:null };
					if (item != items.last()) 
						tiefoundInside.push(tiefound);
					else
						tiefoundLast.push(tiefound);
				}
			}
		
			// ties inside
			for (tiefound in tiefoundInside)
			{
				trace('SEARCH FOR ' + tiefound.targetpos + ' ' + tiefound.notenr);
				for (item in items)
				{
					if (item.position == tiefound.targetpos && item.level == tiefound.level) {
						trace('FOUND pos and level');
					}
				}
			}
			tiefoundInside = [];
		}
	}
	
	
}


typedef TieFound = {
	position:Int,
	noteval:Int,
	notenr: Int,
	level:Int,
	targetpos:Int,
	item: NotenrItem,
	targetItem:NotenrItem,
}


typedef NotenrItem = {
	partposition:Int,
	position:Int, 
	noteval: Int, 
	level:Int, 
	notenr:Int, 
	midinr:Int, 
	headsign:ESign,
	keysign:ESign,
	notename:String, 
	tie: Bool ,
}




class PartNotesToNotenrCalculator {
	var part:NPart;
	var signstable:Map<Int, ESign>;
	var partkey:EKey;
	var partclef:EClef;
	
	public function new(part:NPart, partclef:nx3.EClef=null, partkey:EKey=null) {
		this.part = part;
		this.partclef = partclef;
		this.partkey = partkey;
	}

	public function getNotnrItems() {
		var map = getPartPositionsNotes(this.part);
		this.signstable = NotenrTools.getSignsTable(this.partkey);		
		var items = partPositionsToNotenr(map, this.partclef, this.partkey);
		return items;
	}
	
	public function partPositionsToNotenr(map:Map < Int, Array<NNote>>, partclef:nx3.EClef=null, partkey:nx3.EKey=null)
	{
		var result = new Array<NotenrItem>(); 
		var positions = ArrayTools.fromHashKeys(map.keys());
		positions.sort(function(a, b) return Reflect.compare(a, b));
		for (position in positions)
		{
			var notes = map.get(position);
			for (note in notes)
			{
				
				for (head in note)
				{
					var cleflevel = NotenrTools.clefLevel(head.level, partclef);
					var keysign = signstable.get(cleflevel);
					//trace([head.level, cleflevel, keysign]);
					var headsign = head.sign;
					
					var notenr = NotenrTools.getSignaffectedNotenr(cleflevel, keysign, headsign);
					var midinr = NotenrTools.getMidinr(notenr);
					var notename = NotenrTools.getNotename(notenr);
					var tie = head.tie != null;
					result.push( { position:position, noteval: ENoteValTools.value(note.value), level:cleflevel, notenr:notenr, midinr:midinr, notename:notename, tie: tie, headsign:headsign, keysign:keysign , partposition:0} );
					
					if (headsign != null && headsign != nx3.ESign.None) this.signstable.set(cleflevel, headsign);
					
				}
			}
		}
		
		return result;
	}
	
	public function getPartPositionsNotes(part:NPart): Map < Int, Array<NNote>> {
		var result:Map<Int, Array<NNote>> = new Map<Int, Array<NNote>>();
		for (voice in part)
		{
			var pos = 0;
			for (note in voice)
			{
				if (!result.exists(pos)) result.set(pos, []);
				result.get(pos).push(note);
				pos += ENoteValTools.value(note.value);
			}
		}
		return result;
	}
	
}

class TestScores {
	
	static public function score1():NScore {
		
	
		return null;
	}
}

class NotenrTools {
	var clef:EClef;
	var key:EKey;
	var table:Map<Int, Int>;
	
	public function new(clef:EClef, key:EKey)
	{
		this.clef = clef;
		this.key = key;
		this.table = getNotenrTable(key);
	}
	
	public function getNotenr(level:Int):Int
	{
		return switch(this.clef)
		{
			case EClef.ClefF: this.table.get(level+12) ;
			case _: this.table.get(level);
		}
	}
	
	
	static public  function getNotenrTable(key:EKey=null, levelmin=-30, levelmax=30):Map<Int, Int> {
		var table = new Map<Int, Int>();
		for (level in levelmin...levelmax) {
			var octave = Math.floor(level / 7);
			var basekey = (level >= 0) ? level % 7 : ((level % 7) + 7) % 7;
			var notenr = EKeysTools.getNotenrBaseMap(key).get(basekey) - 12*octave;
			//trace ([level, basekey, octave, midinote]);
			table.set(level, notenr);
		}
		return table;
	}
	
	static public function getSignsTable(key:EKey= null, levelmin = -30, levelmax = 30):Map<Int, ESign> {
		var table = new Map<Int, ESign>();
		for (level in levelmin...levelmax) {
			var octave = Math.floor(level / 7);
			var basekey = (level >= 0) ? level % 7 : ((level % 7) + 7) % 7;
			var sign = EKeysTools.getSignsBaseMap(key).get(basekey);
			//trace ([level, basekey, octave, midinote]);
			table.set(level, sign);
		}
		return table;
	}
	
	
	static public function getNotename(notenr:Int):String
	{
		var base = ['C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B'];
		var bnr = (notenr >= 0) ? notenr % 12 : ((notenr % 12)+12) % 12;
		var octave = (notenr >= 0) ? Math.floor(notenr / 12) : Math.floor(notenr / 12) ;
		var bname = base[bnr];
		//trace([notenr, bnr, octave, bname]);
		return '$bname[$octave]';
	}
	
	static public function getMidinr(notenr:Int) return notenr + 60;
	
	static public function clefLevel(level:Int, clef:EClef) {
		if (clef == null) return level;
		return switch clef {
			case EClef.ClefC: level + 6;
			case EClef.ClefF: level + 12;
			case _: level;
		}
	}
	
	static var stemtonestable = NotenrTools.getNotenrTable(EKey.Natural);
	
	static public function getSignaffectedNotenr(level:Int, keysign:nx3.ESign, headsign:nx3.ESign):Int
	{
		var sign = keysign;
		if (headsign != null && headsign != keysign && headsign != ESign.None) sign = headsign;
		//trace([level, keysign, headsign, sign]);
		var stemtonenr  = stemtonestable.get(level);
		if (sign == null) return stemtonenr;
		return switch sign {
			case ESign.Natural: stemtonenr;
			case ESign.Flat: stemtonenr - 1;
			case ESign.DoubleFlat: stemtonenr - 2;
			case ESign.Sharp: stemtonenr + 1;
			case ESign.DoubleSharp: stemtonenr + 2;
			case _: stemtonenr;
		}
		
	}
}

class NotenrTestItems {

	static public function testTies():nx3.NParts {
		var p1 = new NPart(
			[ 
				new NVoice([
					new NNote([new NHead(0, ESign.None)]),
					new NNote([new NHead(0, ESign.None)]),
					//new NNote([new NHead(0, ESign.None, ETie.Tie(EDirectionUAD.Auto, 0))]),
					//new NNote([new NHead(0, ESign.None)]), 
					//new NNote([new NHead(0, ESign.None)]), 
					//new NNote([new NHead(0, ESign.Flat, ETie.Tie(EDirectionUAD.Auto, 0))]),
					//new NNote([new NHead(0, ESign.None, ETie.Tie(EDirectionUAD.Auto, 0))]),
				]), 
				
				new NVoice([
					new NNote([new NHead(0, ESign.None, ETie.Tie(EDirectionUAD.Auto, 0))], ENoteVal.Nv2), 
				]),
				
			],
			nx3.EClef.ClefG, 
			nx3.EKey.Flat2
		);
		var p2 = new NPart(
			[ 
				new NVoice([
					new NNote([new NHead(0, ESign.None)]), 
					new NNote([new NHead(0, ESign.None)]), 
				]),
				/*
				new NVoice([
					new NNote([new NHead(2, ESign.None)]), 
				]),
				*/
			]
			//,
			//nx3.EClef.ClefG, 
			//nx3.EKey.Natural
		);
		
		
		return [p1, p2];
	}		
	
	
	
	static public function testTwoVoices():nx3.NParts {
		var p1 = new NPart(
			[ 
				new NVoice([
					new NNote([new NHead(0, ESign.Flat)]), 
					new NNote([new NHead(0, ESign.None)]), 
				]), 
				new NVoice([
					new NNote([new NHead(0, ESign.Sharp)]), 
				]),			
			],
			nx3.EClef.ClefG, 
			nx3.EKey.Natural
		);
		return [p1];
	}	

	
	static public function testParts0():nx3.NParts {
		var p1 = new NPart(
			[ new NVoice([
				new NNote([new NHead(0, ESign.None)]), 
				new NNote([new NHead(3, ESign.Natural)]),
				new NNote([new NHead(0, ESign.None)]), 
				new NNote([new NHead(1, ESign.None)]), 
				new NNote([new NHead(1, ESign.None)]), 
				new NNote([new NHead(2, ESign.None)]), 
				new NNote([new NHead(2, ESign.None)]), 
				new NNote([new NHead(3, ESign.None)]), 
			]), ],
			nx3.EClef.ClefG, 
			nx3.EKey.Sharp3
			);
		return [p1];
	}	
	
	static public function testParts1():nx3.NParts {
		var p1 = new NPart(
			[ new NVoice([new NNote([new NHead(0)]), new NNote([new NHead(1)]), new QNote4(2), new QNote4(3), new QNote4(4), new QNote4(5), new QNote4(6), ]), 		],
				nx3.EClef.ClefG, 
				nx3.EKey.Flat1
			);
		var p2 = new NPart([ new NVoice([new QNote4(0), new QNote4(1), new QNote4(2), new QNote4(3), new QNote4(4), new QNote4(5), new QNote4(6), ]), ]
			, null
			, null //nx3.EKey.Sharp1
		);
		return [p1, p2];
	}

	static public function testParts2():nx3.NParts {
		var p1 = new NPart([
			new NVoice([new QNote4(0), new QNote4(0), new QNote4(0), new QNote4(0), ]),
			new NVoice([new QNote2(2), new QNote4(true, 2), new QNote8(2), ]),
		]);
		
		var p2 = new NPart([
			new NVoice([new QNote4(0), new QNote4(0), new QNote4(0), new QNote4(0), ]),
			new NVoice([new QNote2(2), new QNote4(true, 2), new QNote8(2), ]),
		]);		
		return [p1, p2];
	}
	
}