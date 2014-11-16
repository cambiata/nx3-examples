package nx3;
import nx3.NScore;
using cx.ArrayTools;

/**
 * ...
 * @author Jonas Nyström
 */
@:access(nx3.PBar)
class PScore
{
	public var nscore(default, null):NScore;

	public function new(nscore:NScore) 
	{
		this.nscore = nscore;
		
	}
	
	var bars:PBars;
	public function getBars():PBars
	{
		#if (trpscore > 0) trace('PScore->getBars()'); #end
		if (this.bars != null) return this.bars;
		this.bars = [];
		for (nbar in this.nscore.nbars)
		{
			var bar = new PBar(nbar);
			bar.score = this;
			this.bars.push(bar);
		}
		return this.bars;
	}
	
	public function getNBars():NBars 
	{
		#if (trpscore > 0) trace('PScore->getNBars()'); #end
		var result:NBars = [];
		for (bar in this.getBars()) result.push(bar.nbar);
		return result;		
	}
	
	var systems:PSystems;
	var prevSystemwidth:Float = 0;
	public function getSystems(systemwidth: Float):PSystems
	{		
		#if (trpscore > 0) trace('PScore->getSystems()'); #end
		if (systemwidth != prevSystemwidth) this.systems = null;
		if (this.systems != null) return this.systems;		

		this.systems = new PScoreSystemsGenerator(this.getBars()).getsSystems([systemwidth]);
		
		for (system in this.systems)	
		{
			system.calculateSystembarXs();
		}
		
		for (system in this.systems)		
		{			
			var ifMoreThan = (system != this.systems.last()) ? 0 : system.getSystemBreakWidth() * .7;			
			new PScoreSystemStretcher(system).stretchTo(system.getSystemBreakWidth(), ifMoreThan );
		}
		return this.systems;
	}
	
	public function getBar(idx:Int):PBar {
		#if (trpscore > 0) trace('PScore->getBar()'); #end
		return (idx < 0 || idx > this.getBars().length) ? null : this.getBars()[idx];
	}
	
	
}