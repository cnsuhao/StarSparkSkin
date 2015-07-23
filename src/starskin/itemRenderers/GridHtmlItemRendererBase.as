//------------------------------------------------------------------------------
//
// ...
// classname: GridHtmlItemRenderer
// author: 喵大斯( blog.csdn.net/aosnowasp )
// created: 2015-7-22
// copyright (c) 2013 喵大斯( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.itemRenderers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;

	import mx.core.IToolTip;
	import mx.core.IUIComponent;
	import mx.core.LayoutDirection;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.ToolTipEvent;
	import mx.managers.IToolTipManagerClient;
	import mx.managers.ToolTipManager;
	import mx.utils.PopUpUtil;

	import spark.components.Grid;
	import spark.components.gridClasses.GridColumn;
	import spark.components.gridClasses.IGridItemRenderer;

	import starskin.comps.UITextField;
	import starskin.namespaces.dx_internal;

	use namespace mx_internal;
	use namespace dx_internal;

	public class GridHtmlItemRendererBase extends UIComponent implements IGridItemRenderer
	{

		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function GridHtmlItemRendererBase()
		{
			super();

			setCurrentStateNeeded = true;
			accessibilityEnabled = false;

			addEventListener( ToolTipEvent.TOOL_TIP_SHOW, toolTipShowHandler );
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  True if the renderer has been created and commitProperties hasn't
		 *  run yet. See commitProperties.
		 */
		private var setCurrentStateNeeded:Boolean = false;

		/**
		 *  @private
		 *  A flag determining if this renderer should play any
		 *  associated transitions when a state change occurs.
		 */
		mx_internal var playTransitions:Boolean = false;

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  grid
		//----------------------------------------

		public function get grid():Grid
		{
			return ( column ) ? column.grid : null;
		}

		//----------------------------------------
		//  rowIndex
		//----------------------------------------

		private var _rowIndex:int = -1;

		[Bindable( "rowIndexChanged" )]

		public function get rowIndex():int
		{
			return _rowIndex;
		}

		public function set rowIndex( value:int ):void
		{
			if( _rowIndex == value )
				return;

			_rowIndex = value;
			dispatchChangeEvent( "rowIndexChanged" );
		}

		//----------------------------------------
		//  down
		//----------------------------------------

		private var _down:Boolean = false;

		public function get down():Boolean
		{
			return _down;
		}

		public function set down( value:Boolean ):void
		{
			if( value == _down )
				return;

			_down = value;
			setCurrentState( getCurrentRendererState(), playTransitions );
		}

		//----------------------------------------
		//  dragging
		//----------------------------------------

		private var _dragging:Boolean = false;

		[Bindable( "draggingChanged" )]

		public function get dragging():Boolean
		{
			return _dragging;
		}

		public function set dragging( value:Boolean ):void
		{
			if( _dragging == value )
				return;

			_dragging = value;
			setCurrentState( getCurrentRendererState(), playTransitions );
			dispatchChangeEvent( "draggingChanged" );
		}

		//----------------------------------------
		//  hovered
		//----------------------------------------

		private var _hovered:Boolean = false;

		public function get hovered():Boolean
		{
			return _hovered;
		}

		public function set hovered( value:Boolean ):void
		{
			if( value == _hovered )
				return;

			_hovered = value;
			setCurrentState( getCurrentRendererState(), playTransitions );
		}

		//----------------------------------------
		//  selected
		//----------------------------------------

		private var _selected:Boolean = false;

		[Bindable( "selectedChanged" )]

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected( value:Boolean ):void
		{
			if( _selected == value )
				return;

			_selected = value;
			setCurrentState( getCurrentRendererState(), playTransitions );
			dispatchChangeEvent( "selectedChanged" );
		}

		//----------------------------------------
		//  showsCaret
		//----------------------------------------

		private var _showsCaret:Boolean = false;

		[Bindable( "showsCaretChanged" )]

		public function get showsCaret():Boolean
		{
			return _showsCaret;
		}

		public function set showsCaret( value:Boolean ):void
		{
			if( _showsCaret == value )
				return;

			_showsCaret = value;
			setCurrentState( getCurrentRendererState(), playTransitions );
			dispatchChangeEvent( "showsCaretChanged" );
		}

		//----------------------------------------
		//  column
		//----------------------------------------

		private var _column:GridColumn = null;

		[Bindable( "columnChanged" )]

		/**
		 * 表示与此项呈示器相关联的列的 GridColumn 对象。
		 * <p>所属 Grid 的 <code>updateDisplayList()</code> 方法会在调用  <code>preprare()</code> 方法之前设置该发展。</p>
		 *
		 * @default null
		 */
		public function get column():GridColumn
		{
			return _column;
		}

		public function set column( value:GridColumn ):void
		{
			if( _column == value )
				return;

			_column = value;
			dispatchChangeEvent( "columnChanged" );
		}

		//----------------------------------------
		//  columnIndex
		//----------------------------------------

		public function get columnIndex():int
		{
			return ( column ) ? column.columnIndex : -1;
		}

		//----------------------------------------
		//  data
		//----------------------------------------

		private var _data:Object = null;
		private var _dataChange:Boolean;

		[Bindable( "dataChange" )] // compatible with FlexEvent.DATA_CHANGE

		/**
		 * 与项呈示器相对应的网格行的数据提供程序项的值。此值与调用 <code>dataProvider.getItemAt(rowIndex)</code> 方法所返回的对象相对应。
		 * <p>项呈示器可以覆盖此属性定义以访问网格的整个行的数据。 </p>
		 *
		 * @default null
		 */
		public function get data():Object
		{
			return _data;
		}

		public function set data( value:Object ):void
		{
			if( _data == value )
				return;

			_data = value;
			_dataChange = true;
			invalidateProperties();
			dispatchChangeEvent( "dataChange" );
		}

		//----------------------------------------
		//  label
		//----------------------------------------

		private var _label:String = "";
		protected var labelChanged:Boolean;

		[Bindable( "labelChanged" )]

		public function get label():String
		{
			return _label;
		}

		public function set label( value:String ):void
		{
			if( _label == value )
				return;

			_label = value;
			labelChanged = true;
			invalidateProperties();
			dispatchChangeEvent( "labelChanged" );
		}

		//----------------------------------------
		//  labelDisplay
		//----------------------------------------

		private var _labelDisplay:UITextField = null;
		private var _labelDisplayChanged:Boolean;

		[Bindable( "labelDisplayChanged" )]

		public function get labelDisplay():UITextField
		{
			return _labelDisplay
		}

		public function set labelDisplay( value:UITextField ):void
		{
			if( _labelDisplay == value )
				return;

			_labelDisplay = value;
			_labelDisplayChanged = true;
			invalidateProperties();
			dispatchChangeEvent( "labelDisplayChanged" );
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		protected function dispatchChangeEvent( type:String ):void
		{
			if( hasEventListener( type ))
				dispatchEvent( new Event( type ));
		}

		public function prepare( hasBeenRecycled:Boolean ):void
		{
		}

		public function discard( willBeRecycled:Boolean ):void
		{
			if( willBeRecycled )
			{
				label = "";
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------

		override protected function createChildren():void
		{
			super.createChildren();

			if( !labelDisplay )
			{
				checkTextField();
			}
		}

		/**
		 * 检查是否创建了textField对象，没有就创建一个。
		 */
		private function checkTextField():void
		{
			if( !labelDisplay )
			{
				createTextField();

				labelDisplay.htmlText = label;
				invalidateProperties();
			}
		}

		/**
		 * 创建文本显示对象
		 */
		protected function createTextField():void
		{
			labelDisplay = new UITextField();
			labelDisplay.wordWrap = true;
			labelDisplay.multiline = true;
			labelDisplay.selectable = true;
			labelDisplay.autoSize = TextFieldAutoSize.LEFT;
			labelDisplay.antiAliasType = AntiAliasType.ADVANCED;
			labelDisplay.mouseWheelEnabled = false;

			addChild( labelDisplay );
		}

		override protected function commitProperties():void
		{
			super.commitProperties();

			if( setCurrentStateNeeded )
			{
				setCurrentState( getCurrentRendererState(), playTransitions );
				setCurrentStateNeeded = false;
			}

			if( labelChanged || _labelDisplayChanged || _dataChange )
			{
				labelDisplay.$htmlText = _label;
				labelChanged = _labelDisplayChanged = _dataChange = false;
			}
		}

		override public function setActualSize( w:Number, h:Number ):void
		{
			super.setActualSize( w, h );

			if( setActualSizeCalled )
			{
				labelDisplay.$width = w;
				labelDisplay.$height = h;
				invalidateSize();
			}
		}

		override protected function measure():void
		{
			super.measure();

			if( isNaN( explicitWidth ))
			{
				measuredWidth = Math.min( labelDisplay.textWidth, isNaN( explicitMaxWidth ) ? DEFAULT_MAX_WIDTH : explicitMaxWidth );
				measuredHeight = Math.min( labelDisplay.textHeight, isNaN( explicitMaxHeight ) ? DEFAULT_MAX_HEIGHT : explicitMaxHeight );
			}
			else
			{
				measuredWidth = Math.max( isNaN( explicitWidth ) ? 0 : explicitWidth, explicitMinWidth );
				measuredHeight = Math.max( isNaN( explicitHeight ) ? 0 : explicitHeight, explicitMinHeight );
			}
		}

		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( width, height );

			initializeRendererToolTip( this );

			labelDisplay.x = 0;
			labelDisplay.y = 0;
			labelDisplay.$width = unscaledWidth;
			labelDisplay.$height = unscaledHeight;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods - ItemRenderer State Support 
		//
		//--------------------------------------------------------------------------

		/**
		 * 返回要应用到呈示器的状态的名称。例如，一个基本项呈示器返回字符串“normal”、“hovered”或“selected”以指定呈示器的状态。
		 * 在处理 touch 交互（或在选择被忽略的情况下的 mouse 交互）时，也可返回“down”和“downAndSelected”。
		 *
		 * <p>如果所需的行为与默认行为不同，则 GridItemRenderer 的子类必须覆盖此方法才会返回值。</p>
		 * <p>在 Flex 4.0 中，三种主要状态为“normal”、“hovered”和“selected”。在 Flex 4.5 中，添加了“down”和“downAndSelected”。</p>
		 *
		 * <p>支持的完整状态集如下所示（按照优先级的顺序）：
		 *    <ul>
		 *      <li>dragging</li>
		 *      <li>downAndSelected</li>
		 *      <li>selectedAndShowsCaret</li>
		 *      <li>hoveredAndShowsCaret</li>
		 *      <li>normalAndShowsCaret</li>
		 *      <li>down</li>
		 *      <li>selected</li>
		 *      <li>hovered</li>
		 *      <li>normal</li>
		 *    </ul>
		 * </p>
		 *
		 * @return 指定要应用到呈示器的状态的名称的字符串。
		 */
		protected function getCurrentRendererState():String
		{
			if( dragging && hasState( "dragging" ))
				return "dragging";

			if( selected && down && hasState( "downAndSelected" ))
				return "downAndSelected";

			if( selected && showsCaret && hasState( "selectedAndShowsCaret" ))
				return "selectedAndShowsCaret";

			if( hovered && showsCaret && hasState( "hoveredAndShowsCaret" ))
				return "hoveredAndShowsCaret";

			if( showsCaret && hasState( "normalAndShowsCaret" ))
				return "normalAndShowsCaret";

			if( down && hasState( "down" ))
				return "down";

			if( selected && hasState( "selected" ))
				return "selected";

			if( hovered && hasState( "hovered" ))
				return "hovered";

			if( hasState( "normal" ))
				return "normal";

			return null;
		}

		//--------------------------------------------------------------------------
		//
		//  Static Methods
		//
		//--------------------------------------------------------------------------

		static mx_internal function initializeRendererToolTip( renderer:IGridItemRenderer ):void
		{
			const toolTipClient:IToolTipManagerClient = renderer as IToolTipManagerClient;

			if( !toolTipClient )
				return;

			const showDataTips:Boolean = ( renderer.rowIndex != -1 ) && renderer.column && renderer.column.getShowDataTips();
			const dataTip:String = toolTipClient.toolTip;

			if( !dataTip && showDataTips )
				toolTipClient.toolTip = "<dataTip>";
			else if( dataTip && !showDataTips )
				toolTipClient.toolTip = null;
		}

		static mx_internal function toolTipShowHandler( event:ToolTipEvent ):void
		{
			var toolTip:IToolTip = event.toolTip;

			const renderer:IGridItemRenderer = event.currentTarget as IGridItemRenderer;

			if( !renderer )
				return;

			const uiComp:IUIComponent = event.currentTarget as IUIComponent;

			if( !uiComp )
				return;

			// If the renderer is partially obscured because the Grid has been 
			// scrolled, we'll put the tooltip in the center of the exposed portion
			// of the renderer.

			var rendererR:Rectangle = new Rectangle( renderer.getLayoutBoundsX(), renderer.getLayoutBoundsY(), renderer.getLayoutBoundsWidth(), renderer.getLayoutBoundsHeight());

			const scrollR:Rectangle = renderer.grid.scrollRect;

			if( scrollR )
				rendererR = rendererR.intersection( scrollR ); // exposed renderer b

			if(( rendererR.height == 0 ) || ( rendererR.width == 0 ))
				return;

			// Determine if the toolTip needs to be adjusted for RTL layout.
			const mirror:Boolean = renderer.layoutDirection == LayoutDirection.RTL;

			// Lazily compute the tooltip text and recalculate its width.
			toolTip.text = renderer.column.itemToDataTip( renderer.data );
			ToolTipManager.sizeTip( toolTip );

			// We need to position the tooltip at same x coordinate, 
			// center vertically and make sure it doesn't overlap the screen.
			// Call the helper function to handle this for us.

			// x,y: tooltip's location relative to the renderer's layout bounds
			// Assume there's no scaling in the coordinate space between renderer.width and toolTip.width 
			const x:int = mirror ? ( renderer.width - toolTip.width ) : ( rendererR.x - renderer.getLayoutBoundsX());
			const y:int = rendererR.y - renderer.getLayoutBoundsY() + (( rendererR.height - toolTip.height ) / 2 );

			var pt:Point = PopUpUtil.positionOverComponent( DisplayObject( uiComp ), uiComp.systemManager, toolTip.width, toolTip.height, NaN, null, new Point( x, y ));
			toolTip.move( pt.x, pt.y );
		}
	}
}
