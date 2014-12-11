package nx3.audio;
import nx3.NBarUtils;
import nx3.NScore;

/**
 * NotenrBarsCalculator
 * @author 
 */
class NotenrBarsCalculator 
{
	var score:NScore;

	public function new(score:NScore) 
	{
		this.score = score;
	}
	
	public function getPartsNotenrItems() {
		var partsNotenerItems = [];
		
		var barvalues = [];
		for (bar in this.score)
		{
			var barvalue = NBarUtils.getValue(bar);
			barvalues.push(barvalue);
		}
		
		var partslist = this.getPartslist();
		var partnr = 0;
		for (parts in partslist)
		{
			var partNotenrItems = new NotenrPartsCalculator(parts, partnr,  barvalues).execute();
			partsNotenerItems.push(partNotenrItems);
			partnr++;
		}
		
		return partsNotenerItems;
	}
	
	public function getPartslist():Array<nx3.NParts>  {
		var partcount = this.score.nbars[0].nparts.length;
		var result = [];
		for (partidx in 0...partcount) {
			var parts = new nx3.NParts();
			for (bar in this.score) {
				var barpart = bar.nparts[partidx];
				parts.push(barpart);
			}
			result.push(parts);
		}
		return result;
	}
	
	
	
}