//------------------------------------------------------------------------------
//
// ...
// classname: ToolTipBorder
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-24
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.skins
{
	import flash.display.Graphics;
	import flash.filters.DropShadowFilter;

	import mx.controls.ToolTip;
	import mx.core.EdgeMetrics;
	import mx.skins.RectangularBorder;

	import spark.primitives.RectangularDropShadow;

	/**
	 * mx.controls.ToolTip 的边框样式
	 * @author AoSnow
	 */
	public class ToolTipBorder extends RectangularBorder
	{
		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function ToolTipBorder()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		private var dropShadow:RectangularDropShadow;

		protected const DROP_SHADOW:DropShadowFilter = new DropShadowFilter( 1, 90, 0, 0.1, 3, 3 );

		/** 指示三角形的宽度  **/
		public static var POINTER_WIDTH:Number = 8;

		/** 指示三角形的高度  **/
		public static var POINTER_HEIGHT:Number = 5;

		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  borderMetrics
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the borderMetrics property.
		 */
		private var _borderMetrics:EdgeMetrics;

		/**
		 *  @private
		 */
		override public function get borderMetrics():EdgeMetrics
		{
			if( _borderMetrics )
				return _borderMetrics;

			var borderStyle:String = getStyle( "borderStyle" );

			switch( borderStyle )
			{
				case "errorTipRight":
				{
					// 提示在右边，箭头指向左边
					_borderMetrics = new EdgeMetrics( POINTER_HEIGHT, 1, 3, 2 );
					break;
				}
				case "errorTipLeft":
				{
					// 提示在左边，箭头指向右边
					_borderMetrics = new EdgeMetrics( 3, 1, POINTER_HEIGHT, 2 );
					break;
				}
				case "errorTipAbove":
				{
					// 提示在上方，箭头指向下面
					_borderMetrics = new EdgeMetrics( 3, 1, 3, POINTER_HEIGHT );
					break;
				}
				case "errorTipBelow":
				{
					// 提示在下方，箭头指向上面
					_borderMetrics = new EdgeMetrics( 3, POINTER_HEIGHT + 2, 3, 2 );
					break;
				}
				default: // "toolTip"
				{
					// 默认没有箭头
					_borderMetrics = new EdgeMetrics( 3, 1, 3, 3 );
					break;
				}
			}

			return _borderMetrics;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  If borderStyle may have changed, clear the cached border metrics.
		 */
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );

			if( styleProp == "borderStyle" || styleProp == "styleName" || styleProp == null )
			{
				_borderMetrics = null;
			}
		}

		/**
		 * 绘制边框
		 * @param x
		 * @param y
		 * @param w
		 * @param h
		 * @param borderColor
		 * @param backgroundAlpha
		 * @param cornerRadius
		 *
		 */
		protected function drawBorder( x:Number, y:Number, w:Number, h:Number, cornerRadius:Number, borderColor:uint, backgroundAlpha:Number ):void
		{
			var g:Graphics = graphics;

			// border
			g.lineStyle( 1, borderColor, backgroundAlpha );

			// 圆角平滑处理，防锯齿
			g.drawRoundRect( x + 0.5, y + 0.5, w, h, cornerRadius << 1, cornerRadius << 1 );
			g.endFill();
		}

		/**
		 * 绘制指示三角形
		 * @param ps 三角形的三个点坐标，第一个点应该是锐角坐标
		 * @param borderColor
		 * @param backgroundAlpha
		 * @param backgroundColor
		 */
		protected function drawPointer( ps:Array, borderColor:uint, borderAlpha:uint, //
										backgroundColor:uint, backgroundAlpha:Number ):void
		{
			var g:Graphics = graphics;

			// border
			g.lineStyle( 1, borderColor, borderAlpha );

			// fill
			g.beginFill( backgroundColor, backgroundAlpha );

			// draw
			g.moveTo( ps[ 0 ], ps[ 1 ]);
			g.lineTo( ps[ 2 ], ps[ 3 ]);
			g.lineTo( ps[ 4 ], ps[ 5 ]);
			g.moveTo( ps[ 0 ], ps[ 1 ]);
			g.endFill();

			// line
			g.lineStyle( 1, backgroundColor, backgroundAlpha );
			g.moveTo( ps[ 2 ], ps[ 3 ]);
			g.lineTo( ps[ 4 ], ps[ 5 ]);
			g.endFill();
		}

		/**
		 *  @private
		 *  Draw the background and border.
		 */
		override protected function updateDisplayList( w:Number, h:Number ):void
		{
			super.updateDisplayList( w, h );

			var borderStyle:String = getStyle( "borderStyle" );
			var backgroundColor:uint = getStyle( "backgroundColor" );
			var backgroundAlpha:Number = getStyle( "backgroundAlpha" );
			var borderColor:uint = getStyle( "borderColor" );
			var borderAlpha:uint = getStyle( "borderAlpha" );
			var cornerRadius:Number = getStyle( "cornerRadius" );
			var paddingTop:Number = getStyle( "paddingTop" );

			var g:Graphics = graphics;
			var pw:Number = 0;
			var ph:Number = 0;
			var halfW:Number = 0;
			var halfH:Number = 0;
			var offset:Number = 7; // 三角形与侧边的偏移距离

			g.clear();

			filters = [];

			switch( borderStyle )
			{
				case "none":
				{
					// Don't draw anything
					break;
				}
				case "errorTipRight":
				{
					pw = POINTER_HEIGHT;
					ph = POINTER_WIDTH;
					halfW = pw >> 1;
					halfH = ph >> 1;

					// background
					drawRoundRect( pw, 0, w - pw, h - 2, 3, backgroundColor, backgroundAlpha );

					// border
					drawBorder( pw, 0, w - pw, h - 2, 3, borderColor, borderAlpha );

					// left pointer 
					drawPointer([ 0, offset + halfH, pw, offset, pw, offset + ph ], //
								borderColor, borderAlpha, //
								backgroundColor, backgroundAlpha );

					break;
				}
				case "errorTipLeft":
				{
					pw = POINTER_HEIGHT;
					ph = POINTER_WIDTH;
					halfW = pw >> 1;
					halfH = ph >> 1;

					// 提示在左边，箭头指向右边
					// background
					drawRoundRect( 0, 0, w - pw, h - 2, 3, backgroundColor, backgroundAlpha );

					// border
					drawBorder( 0, 0, w - pw, h - 2, 3, borderColor, borderAlpha );

					// right pointer 
					drawPointer([ w, offset + halfH, w - pw - 0.5, offset, w - pw - 0.5, offset + ph ], //
								borderColor, borderAlpha, //
								backgroundColor, backgroundAlpha );

					break;
				}
				case "errorTipAbove":
				{
					pw = POINTER_WIDTH;
					ph = POINTER_HEIGHT;
					halfW = pw >> 1;
					halfH = ph >> 1;

					// 提示在上方，箭头指向下面
					// background 
					drawRoundRect( 0, 0, w, h - ph, 3, backgroundColor, backgroundAlpha );

					// border
					drawBorder( 0, 0, w, h - ph, 3, borderColor, borderAlpha );

					// bottom pointer 
					drawPointer([ offset + halfW, h, offset, h - ph, offset + pw, h - ph ], //
								borderColor, borderAlpha, //
								backgroundColor, backgroundAlpha );

					break;
				}
				case "errorTipBelow":
				{
					pw = POINTER_WIDTH;
					ph = POINTER_HEIGHT;
					halfW = pw >> 1;
					halfH = ph >> 1;
					h -= 2;

					// 提示在下方，箭头指向上面
					// background 
					drawRoundRect( 0, ph, w, h - ph, 3, backgroundColor, backgroundAlpha );

					// border
					drawBorder( 0, ph, w, h - ph, 3, borderColor, borderAlpha );

					// top pointer 
					drawPointer([ offset + halfW, 0, offset, ph, offset + pw, ph ], //
								borderColor, borderAlpha, //
								backgroundColor, backgroundAlpha );

					break;
				}
				default: //Tooltip
				{
					// face
					drawRoundRect( 3, 1, w - 6, h - 4, cornerRadius, backgroundColor, backgroundAlpha )

					// border
					drawBorder( 3, 1, w - 6, h - 4, cornerRadius, borderColor, backgroundAlpha );

					break;
				}
			}

			if( getStyle( "dropShadowVisible" ))
				filters = [ DROP_SHADOW ];
		}
	}
}
