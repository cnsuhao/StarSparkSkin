//------------------------------------------------------------------------------
//
// 简单页面
// classname: Pager
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-3
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.comps
{
	import spark.components.Panel;

	/**
	 * 标题栏背景颜色
	 * @default 0xffffff
	 */
	[Style( name = "headerBackColor", type = "uint", inherit = "no" )]
	
	/**
	 * 是否显示标题栏
	 * @default true
	 */
	[Style( name = "showHeader", type = "Boolean", enumeration = "true,false", inherit = "no" )]

	public class Pager extends Panel
	{
		public function Pager()
		{
			super();
		}
	}
}
