package haxe.root;
import haxe.root.*;

@SuppressWarnings(value={"rawtypes", "unchecked"})
public  class Xml_iterator_181__Fun extends haxe.lang.Function
{
	public    Xml_iterator_181__Fun(haxe.root.Array<haxe.root.Array> x, haxe.root.Array<java.lang.Object> cur)
	{
		super(0, 0);
		this.x = x;
		this.cur = cur;
	}
	
	
	@Override public   java.lang.Object __hx_invoke0_o()
	{
		int __temp_stmt253 = 0;
		{
			int __temp_arrIndex186 = 0;
			int __temp_arrVal184 = ((int) (haxe.lang.Runtime.toInt(this.cur.__get(__temp_arrIndex186))) );
			int __temp_arrRet185 = __temp_arrVal184++;
			int __temp_expr254 = ((int) (haxe.lang.Runtime.toInt(this.cur.__set(__temp_arrIndex186, __temp_arrVal184))) );
			__temp_stmt253 = __temp_arrRet185;
		}
		
		haxe.root.Array<haxe.root.Xml> __temp_stmt255 = ((haxe.root.Array<haxe.root.Xml>) (((haxe.root.Array) (this.x.__get(0)) )) );
		return __temp_stmt255.__get(__temp_stmt253);
	}
	
	
	public  haxe.root.Array<haxe.root.Array> x;
	
	public  haxe.root.Array<java.lang.Object> cur;
	
}

