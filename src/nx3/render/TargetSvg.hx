package nx3.render;

import nx3.render.scaling.TScaling;
import nx3.render.svg.Elements;
import snap.Snap;

/**
 * ...
 * @author Jonas Nyström
 */
class TargetSvg implements ITarget
{
	var targetDivId:String;
	var jsFileName:String;
	var scaling:TScaling;
	var snap:Snap;

	public function new(targetDivId: String, scaling:TScaling, jsFileName:String=null) 
	{
		this.targetDivId = targetDivId;
		this.scaling = scaling;
		this.jsFileName = jsFileName;
		this.snap = new Snap(targetDivId);
	}
		
	public function test():Void 
	{
		var bigCircle = this.snap.circle(150, 150, 100);
		bigCircle.attr({
    		fill: "#bada55",
    		stroke: "#000",
    		strokeWidth: 5
		});
	}
	
	public function test2():Void
	{
		var c = this.snap.circle(250, 250, 100);
		c.attr({
    		fill: "#ff0000",
    		stroke: "#000",
    		strokeWidth: 3
		});
	}
	
	/* INTERFACE nx3.render.ITarget */
	
	public function testLines(x:Float, y:Float, width:Float):Void 
	{
		//this.snap.line(x, y, x + width, y);
		//this.target.graphics.lineStyle(this.scaling.linesWidth, 0xAAAAAA);	
		
		for (i in -2...3)
		{
			var cy = y + i * scaling.space;
			//this.target.graphics.moveTo(x, cy);
			//this.target.graphics.lineTo(x + width, cy);			
			var line = this.snap.line(x, cy, x + width, cy);
			line.attr( {
				stroke: "#000",
				strokeWidth: scaling.linesWidth,
			});
		}		
	}
	
	/* INTERFACE nx3.render.ITarget */
	
	public function testSymbol(x:Float, y:Float, xmlStr:String=null):Void 
	{
		if (xmlStr == null) xmlStr = Elements.noteWhite;
		var xml = Xml.parse(xmlStr);
		var gPathD = xml.firstElement().firstChild().firstChild().get('d');
		trace(gPathD);		
		
		
		var p:SnapElement = this.snap.path(gPathD).attr({
	        fill: "#000000",
	        stroke: "none",
    	});		

		y = y  + this.scaling.svgY; // * this.scaling.svgScale;
		x = x + this.scaling.svgX; // * 1; // + this.scaling.svgX * this.scaling.svgScale;

		var g:SnapElement = this.snap.el('svg', {
			x:x,
			y:y,
			});
		g.append(p);
		
		var sc =  this.scaling.svgScale;
		p.transform('matrix($sc,0,0,$sc,0,0)');
		//p.transform('matrix(1, .5, 2, .5, .5)');
		
		
		
		
		//trace(xmlStr);
	}

	/*
	public function testSymbol(x:Float, y:Float)
	{
		
	}
	*/

	/*
	function drawShape(shape:Shape, x:Float, y:Float, rect:Rectangle)
	{
		if (shape == null) return;
		shape.x = x + rect.x * scaling.halfNoteWidth + scaling.svgX;
		shape.y = y + rect.y * scaling.halfSpace + scaling.svgY;
		this.target.addChild(shape);
	}	
	*/
	
	
	/*
	public function getHtml():String
	{
		var html = '<!DOCTYPE html><html lang="en"><head>	<meta charset="utf-8"/>	<title>_nx3-examples</title>	<meta name="description" content="" />	<script src="snap.svg.js"></script></head><body>		  <svg id="{$this.targetDivId}" style="width:500px;height:500px;background:green;">	  </svg>		<script src="{this.jsFileName}"></script>	<script>	</script></body></html>';
		return html;
	}
	*/
	
}