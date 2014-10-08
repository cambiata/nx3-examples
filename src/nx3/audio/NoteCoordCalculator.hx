package nx3.audio;
import haxe.ds.ObjectMap;
import nx3.geom.Point;
import nx3.PScore;
import nx3.PSystem;
import nx3.render.scaling.Scaling;
import nx3.render.scaling.TScaling;
import thx.core.Tuple.Tuple2;
using cx.ArrayTools;

/**
 * ...
 * @author Jonas Nyström
 */
class NoteCoordCalculator
{

	public function new() 
	{
		
	}
	
	public function getCoordinatesFromTopVoice(pscore:PScore):Array<{pnote:PNote, x:Float, y:Float, pos:Int}>
	{
		var sys:PSystem = pscore.getSystems(1000)[0];
		//var coords: Map<Int, {x:Float, y:Float, pos>> = new Map<Int, Tuple2<Float, Float>>();
		var pos = 0;
		var coords:Array<{pnote:PNote, x:Float, y:Float, pos:Int}> = [];
		
		for (sysbar in sys.getSystembars())
		{
			var part = sysbar.bar.getPart(0);
			var voice = part.getVoice(0);
			for (pnote in voice.getNotes())
			{				
				var length = ENoteValTools.value(pnote.nnote.value);
				var barX = sysbar.getXPosition() + sysbar.getBarMeasurements().getContentXPosition();				
				var noteX = pnote.getXPosition();					
				coords.push( { pnote:pnote, x:barX+noteX, y:20, pos:pos } );				
				pos += length;				
			}
		}		
		//trace(getValueLenghtForTopVoice(pscore));
		return coords;
	}	
	
	public function getValueLenghtForTopVoice(pscore:PScore)
	{
		var sys:PSystem = pscore.getSystems(1000)[0];
		return sys.getValue();
	}
	
	public function getPlayCoordinates(coords:Array<{pnote:PNote, x:Float, y:Float, pos:Int}>, noteValue:Int, soundLenght:Float, scaling:TScaling=null)
	{
		
		if (scaling == null) scaling = Scaling.NORMAL;
		
		var result = new Map<Int, Point>();
		
		for (coord in coords)
		{
			var pos = coord.pos;
			var posDelta = pos / noteValue;
			var soundPos = Std.int(soundLenght * posDelta);
			result.set(soundPos, new Point(coord.x * scaling.unitX, coord.y * scaling.unitY ) );
			trace([soundPos, result.get(soundPos)]);
		}
		
		return result;
	}
	
}