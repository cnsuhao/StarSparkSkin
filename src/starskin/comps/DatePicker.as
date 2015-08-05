//------------------------------------------------------------------------------
//
// ...
// classname: DatePicker
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-31
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.comps
{
	import flash.events.MouseEvent;

	import mx.collections.ArrayList;

	import spark.components.DataGroup;
	import spark.components.DataRenderer;
	import spark.components.supportClasses.ButtonBase;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.SkinnableTextBase;
	import spark.events.RendererExistenceEvent;

	import starskin.events.DatePickerEvent;
	import starskin.itemRenderers.IR_DatePickerWeek;
	import starskin.vo.DatePickerCellSet;

	//----------------------------------------
	//  events
	//----------------------------------------

	/** 当日期选择器中的单元格被点击时派发  **/
	[Event( name = "dateSelected", type = "starskin.events.DatePickerEvent" )]

	/** 当日期选择器所选择的内容发生变化时派发  **/
	[Event( name = "dateChanged", type = "starskin.events.DatePickerEvent" )]

	/** 当与日期选择器执行清空时派发  **/
	[Event( name = "dateClear", type = "starskin.events.DatePickerEvent" )]

	//----------------------------------------
	//  states
	//----------------------------------------

	/**
	 * 切换到选择日类型
	 */
	[SkinState( "dayType" )]

	/**
	 * 切换到选择月类型
	 */
	[SkinState( "monthType" )]

	/**
	 * 切换到选择年类型
	 */
	[SkinState( "yearType" )]

	[DefaultProperty( "txtInput" )]

	/**
	 * 日期选择控件（支持直接切换到“年、月、日”类型进行选择，而不是生硬的使用按钮一页页找）
	 * <p>由于 <code>mx.controls.DateField</code> 极其不友好，而且不支持皮肤，而且习惯了 JS 开源日期控件 Zebra_DatePicker
	 * 的使用，故此处还原 AS3 版本的 Zebra_DatePicker 来提供使用。</p>
	 * @author AoSnow
	 */
	public class DatePicker extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/** 日期选择器切换到“日”类型状态的定义值  **/
		public static const DAY_TYPE:int = 0;

		/** 日期选择器切换到“月”类型状态的定义值  **/
		public static const MONTH_TYPE:int = 1;

		/** 日期选择器切换到“年”类型状态的定义值  **/
		public static const YEAR_TYPE:int = 2;

		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function DatePicker()
		{
			super();

			// 初始化日期
			_tmpDate = new Date();

			// 初始让状态能够切换到默认的“日”选择状态
			dateTypeChanged = true;
			invalidateSkinState();
		}

		//--------------------------------------------------------------------------
		//
		//	Skin parts
		//
		//--------------------------------------------------------------------------

		[SkinPart( required = "false" )]
		/** 上一页按钮  **/
		public var previousButton:ButtonBase;

		[SkinPart( required = "false" )]
		/** 中心切换日期选择类型按钮  **/
		public var centerButton:ButtonBase;

		[SkinPart( required = "false" )]
		/** 下一页按钮  **/
		public var nextButton:ButtonBase;

		[SkinPart( required = "false" )]
		/** 清除按钮  **/
		public var clearButton:ButtonBase;

		[SkinPart( required = "false" )]
		/** 星期几头单元的容器（来源于 skin，需要 layout 和 ItemRenderer 设置）  **/
		public var weekGroup:DataGroup;

		[SkinPart( required = "false" )]
		/** 日期单元的容器（来源于 skin，需要 layout 和 ItemRenderer 设置）  **/
		public var dateGroup:DataGroup;

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  DAY_MS
		//----------------------------------------

		/**
		 * 一天的毫秒数
		 */
		protected const DAY_MS:Number = 86400000;

		//----------------------------------------
		//  MONTH_EN
		//----------------------------------------

		/**
		 * 月份英文缩写（3个字母）
		 * <ol>
		 * <li>Jan.一月</li>
		 * <li>Feb.二月</li>
		 * <li>Mar.三月</li>
		 * <li>Apr.四月</li>
		 * <li>May.五月</li>
		 * <li>Jun.六月</li>
		 * <li>Jul.七月</li>
		 * <li>Aug.八月</li>
		 * <li>Sep.九月</li>
		 * <li>Oct.十月</li>
		 * <li>Nov.十一月</li>
		 * <li>Dec.十二月</li>
		 * </ol>
		 */
		protected const MONTH_EN:Array = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];

		//----------------------------------------
		//  WEEK_EN
		//----------------------------------------

		/**
		 * 星期英文缩写
		 * <ol>
		 * <li>星期一： Mon.=Monday </li>
		 * <li>星期二： Tues.=Tuesday </li>
		 * <li>星期三： Wed.=Wednesday </li>
		 * <li>星期四： Thur.=Thursday </li>
		 * <li>星期五： Fri.=Friday </li>
		 * <li>星期六： Sat.=Saturday </li>
		 * <li>星期天： Sun.=Sunday</li>
		 * </ol>
		 */
		protected const WEEK_EN:Array = [ "Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat" ];

		//----------------------------------------
		//  year area
		//----------------------------------------

		/** 最近一次年份排列时的开始年份  **/
		protected var startYear:Number = 0;

		/** 最近一次年份排列时的结束年份  **/
		protected var endYear:Number = 0;

		//----------------------------------------
		//  dateType
		//----------------------------------------

		private var _dateType:int;
		protected var dateTypeChanged:Boolean;

		// 可使用的选择模式，根据所设置的 format 决定
		protected var validTypes:Array = [ 0, 1, 2 ];

		/**
		 * 日期选择控件当前的选择类型
		 * <ul>
		 * <li>0 - 选择日类型（默认）</li>
		 * <li>1 - 选择月类型</li>
		 * <li>2 - 选择年类型</li>
		 * </ul>
		 * @return
		 */
		public function get dateType():int
		{
			return _dateType;
		}

		public function set dateType( value:int ):void
		{
			// 非法值
			if( value < 0 )
				value = 0;

			// 大于2，则回到初始0，这样可以实现累加来达到循环的目的
			if( value > 2 )
				value = 0;

			if( _dateType == value || validTypes.indexOf( value ) == -1 )
				return;

			_dateType = value;
			dateTypeChanged = true;
			invalidateProperties();
			invalidateSkinState();
		}

		//----------------------------------------
		//  dateString
		//----------------------------------------

		private var _selectedTime:Number = 0; // 当前所选择的时间，与 dateString 对应，用于还原中断选择时时间
		private var _date:Date; // 用户所选择的日期
		private var _tmpDate:Date; // 用于处理切换翻页时的日期
		private const TMP_DATE:Date = new Date(); // 用于处理选择时间的日期对象
		private var _dateString:String;
		protected var dateSetChanged:Boolean;

		[Bindable( event = "dateChanged" )]
		/**
		 * 日期控件当前选择的内容
		 * <p><b>注意</b>：该内容会随着用户的选择而改变。</p>
		 * @return
		 */
		public function get dateString():String
		{
			return _dateString;
		}

		/**
		 * 通过指定年月日数值来更改当前选择的内容
		 * @param year 年份
		 * @param month 月份1-12
		 * @param date 日期 1-31
		 */
		public function setFullYear( year:Number, month:Number, date:Number ):void
		{
			if( _date && _date.fullYear == year && _date.month == month && _date.date == date )
				return;

			_date = _date || new Date();

			if( year > 0 )
				_date.setFullYear( year );

			if( month > 0 && month <= 12 )
				_date.setMonth( month - 1 );

			if( date > 0 && date <= 31 )
				_date.setDate( date );

			dateSetChanged = true;
			invalidateProperties();
		}

		/**
		 * 通过设置时间戳来更改当前选择的内容
		 * @param timestamp 自1970年1月1日以来的毫秒数（单位：毫秒）
		 */
		public function setTimestamp( timestamp:Number ):void
		{
			if( _date && _date.time == timestamp )
				return;

			_date = _date || new Date();

			_date.time = timestamp;
			dateSetChanged = true;
			invalidateProperties();
		}

		//----------------------------------------
		//  txtInput
		//----------------------------------------

		private var _txtInput:SkinnableTextBase;
		protected var txtInputChanged:Boolean;

		/**
		 * 与日期选择控件成绑定关系的文本显示控件，用于显示所选内容
		 * @return
		 */
		public function get txtInput():SkinnableTextBase
		{
			return _txtInput;
		}

		public function set txtInput( value:SkinnableTextBase ):void
		{
			if( _txtInput == value )
				return;

			_txtInput = value;
			_txtInput.editable = false;
			txtInputChanged = true;
			invalidateProperties();
		}

		//----------------------------------------
		//  alwaysShowClear
		//----------------------------------------

		private var _alwaysShowClear:Boolean;
		private var alwaysShowClearChanged:Boolean;

		/**
		 * 是否始终显示“清除”按钮
		 * <p>清除按钮用于清除所选定的内容，以及所绑定文本控件的内容</p>
		 * <p>默认情况下，“清除”按钮是隐藏状态，只有当选择了内容后才会显示出来。</p>
		 * @return
		 */
		public function get alwaysShowClear():Boolean
		{
			return _alwaysShowClear;
		}

		public function set alwaysShowClear( value:Boolean ):void
		{
			if( _alwaysShowClear == value )
				return;

			_alwaysShowClear = value;
			alwaysShowClearChanged = true;
			invalidateProperties();
		}

		//----------------------------------------
		//  format
		//----------------------------------------

		private var _format:String = "Y-m-d";
		protected var formatChanged:Boolean;
		protected const FORMAT_YEAR:Array = [ "Y", "y" ];
		protected const FORMAT_MONTH:Array = [ "M", "m", "n" ];
		protected const FORMAT_DAY:Array = [ "D", "d", "j" ];

		/**
		 * 日期内容的格式
		 * <p>
		 * 日期内容格式可以是以下编码加任意符合的组合：
		 * <ul>
		 * <li>Y - 4 位数字完整表示的年份：例如：1999 或 2003</li>
		 * <li>y - 2 位数字表示的年份：99 或 03</li>
		 * <li>M - 三个字母缩写表示的月份：Jan 到 Dec</li>
		 * <li>m - 数字表示的月份，有前导零的 2 位数字：01 到 12</li>
		 * <li>n - 数字表示的月份，没有前导零：1 到 12</li>
		 * <li>D - 星期中的第几天，文本表示，3 个字母：Mon 到 Sun</li>
		 * <li>d - 月份中的第几天，有前导零的 2 位数字：01 到 31</li>
		 * <li>j - 月份中的第几天，没有前导零：1 到 31</li>
		 * </ul>
		 * </p>
		 * @return
		 */
		public function get format():String
		{
			return _format;
		}

		public function set format( value:String ):void
		{
			if( _format == value )
				return;

			_format = value;
			formatChanged = true;
			invalidateProperties();
		}

		//--------------------------------------------------------------------------
		//
		//	Override methods
		//
		//--------------------------------------------------------------------------

		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );

			if( instance is ButtonBase )
			{
				( instance as ButtonBase ).addEventListener( MouseEvent.CLICK, buttonClickHandler );
			}

			if( instance == dateGroup )
			{
				dateGroup.addEventListener( RendererExistenceEvent.RENDERER_ADD, dataGroupRendererHandler );
				dateGroup.addEventListener( RendererExistenceEvent.RENDERER_REMOVE, dataGroupRendererHandler );
			}

			if( instance == weekGroup )
			{
				weekGroup.dataProvider = new ArrayList([ "日", "一", "二", "三", "四", "五", "六" ]);
				weekGroup.addEventListener( RendererExistenceEvent.RENDERER_ADD, weekGroupRendererAddHandler );
			}
		}

		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );

			if( instance is ButtonBase )
			{
				( instance as ButtonBase ).removeEventListener( MouseEvent.CLICK, buttonClickHandler );
			}

			if( instance == dateGroup )
			{
				dateGroup.removeEventListener( RendererExistenceEvent.RENDERER_ADD, dataGroupRendererHandler );
				dateGroup.removeEventListener( RendererExistenceEvent.RENDERER_REMOVE, dataGroupRendererHandler );
			}

			if( instance == weekGroup )
			{
				weekGroup.dataProvider.removeAll();
				weekGroup.removeEventListener( RendererExistenceEvent.RENDERER_ADD, weekGroupRendererAddHandler );
			}
		}

		override protected function commitProperties():void
		{
			if( formatChanged )
			{
				changeValidTypes();
				skin.validateNow();
			}

			super.commitProperties();

			if( dateSetChanged )
			{
				updateContentByFormat();
				dateSetChanged = false;
			}

			if( formatChanged )
			{
				changeValidTypes();
				updateContentByFormat();
				formatChanged = false;
			}

			// 选择类型
			if( dateTypeChanged )
			{
				updateDateTypeContent( dateType );
				dateTypeChanged = false;
			}

			// 清除按钮可见性
			var isShowClear:Boolean = false;

			if( txtInput )
			{
				isShowClear = txtInput.text.length > 0;

				if( alwaysShowClear )
					isShowClear = true;
			}
			else
			{
				isShowClear = false;
			}

			// alwaysShowClear 状态
			if( alwaysShowClearChanged )
			{
				if( alwaysShowClear )
				{
					isShowClear = true;
				}
				else
				{
					isShowClear = txtInput && txtInput.text.length > 0;
				}

				alwaysShowClearChanged = false;
			}
			clearButton.visible = clearButton.includeInLayout = isShowClear;
		}

		override protected function getCurrentSkinState():String
		{
			switch( dateType )
			{
				case 1:
				{
					return "monthType";
				}
				case 2:
				{
					return "yearType";
				}
				default:
				{
					return "dayType";
				}
			}
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * 作为弹出内容时，在弹出前重置到选定时间点或者当前时间点
		 */
		public function updateBeforeOpen():void
		{
			if( _date )
				_date.time = _selectedTime;
			_dateType = validTypes[ 0 ];
			dateTypeChanged = true;
			invalidateProperties();
			invalidateSkinState();
		}

		/**
		 * 清除当前选择的内容
		 */
		public function clear():void
		{
			if( txtInput )
				txtInput.text = "";

			// 派发事件
			dispatchChangeEvent( DatePickerEvent.CLEAR, _dateString );

			// 清 除了选择内容后，要对“清除按钮”作显示/隐藏处理
			invalidateProperties();
		}

		protected function updateDateTypeContent( type:int ):void
		{
			if( _date )
				_tmpDate.time = _date.time;
			else
				_tmpDate.time = ( new Date()).time;

			// 根据 _date 的值，以及选择类型初始化列表内容
			switch( type )
			{
				case 1:
				{
					// 月内容初始化
					updateMonthTypeContent( _tmpDate );
					break;
				}
				case 2:
				{
					// 年内容初始化
					updateYearTypeContent( _tmpDate );
					break;
				}
				default:
				{
					// 日内容初始化
					updateDayTypeContent( _tmpDate );
				}
			}
		}

		protected function updateDayTypeContent( value:Date ):void
		{
			// 日期：6行7列
			var date:Date = new Date(); // 当前日期
			var itemWidth:Number = dateGroup.width / 7;
			var itemHeight:Number = dateGroup.height / 6;

			// 清除所有
			if( dateGroup.dataProvider )
				dateGroup.dataProvider.removeAll();

			// 表头信息
			setTitleContent( value.fullYear + " 年，" + ( value.month + 1 ) + " 月" );

			// 把月份的1号放在第一行，并按星期几决定位置，前置补足上个月的最后几天
			// 末行不足的位置，补足下个月的前几天
			// 补足的单元，都不支持点击
			var curMonth:Number = value.month;
			var selDayTime:Number = _date ? _date.time : 0; // 毫秒时间
			var todayTime:Number = date.time;
			var dayArr:Array = [];

			// 寻址：月份的第一天
			date.time = value.time - ( value.date - 1 ) * DAY_MS;
			var fstDay:Number = date.day;
			var fstDayTime:Number = date.time;
			var startTime:Number = fstDayTime - DAY_MS * fstDay;

			for( var i:int = 0; i < 42; i++ )
			{
				date.time = startTime + i * DAY_MS;

				var data:DatePickerCellSet = new DatePickerCellSet();
				data.label = String( date.date );
				data.width = itemWidth;
				data.height = itemHeight;
				data.color = getStyle( "color" );
				data.time = date.time;

				if( date.month != curMonth )
				{
					data.color = 0xcccccc;
					data.backgroundColor = 0xE8E8E8;
					data.enabled = false;
				}
				else
				{
					if( date.day == 0 || date.day == 6 )
					{
						data.color = 0x5BB4C1;
						data.backgroundColor = 0xEEF4F6;
					}

					TMP_DATE.time = todayTime;

					if( dateEqual( date, TMP_DATE ))
					{
						data.color = 0xADC6D1;
						data.bold = "bold";
					}

					TMP_DATE.time = selDayTime;

					if( dateEqual( date, TMP_DATE ))
					{
						data.color = 0xffffff;
						data.backgroundColor = 0xADC6D1;
					}
				}

				dayArr.push( data );
			}

			dateGroup.dataProvider = new ArrayList( dayArr );
		}

		protected function dateEqual( d1:Date, d2:Date ):Boolean
		{
			return d1.fullYear == d2.fullYear && d1.month == d2.month && d1.date == d2.date;
		}

		protected function updateMonthTypeContent( value:Date ):void
		{
			// 月份：4行3列
			var date:Date = new Date(); // 当前日期
			var itemWidth:Number = dateGroup.width / 3;
			var itemHeight:Number = dateGroup.height / 4;

			// 清除所有
			if( dateGroup.dataProvider )
				dateGroup.dataProvider.removeAll();

			// 从1月到12月顺序排列
			var selMonth:Number = _date ? _date.month : 0;
			var selYear:Number = _date ? _date.fullYear : 0;
			var curMonth:Number = date.month;
			var curYear:Number = date.fullYear;
			var monthArr:Array = [];

			// 表头信息
			setTitleContent( value.fullYear + " 年" );

			// 对应时间
			date.time = value.time;

			for( var i:int = 0; i < 12; i++ )
			{
				date.month = i;

				var data:DatePickerCellSet = new DatePickerCellSet();
				data.label = ( i + 1 ) + " 月";
				data.width = itemWidth;
				data.height = itemHeight;
				data.color = getStyle( "color" );
				data.time = date.time;

				if( i == curMonth && value.fullYear == curYear )
				{
					data.color = 0xADC6D1;
					data.bold = "bold";
				}

				if( i == selMonth && value.fullYear == selYear )
				{
					data.color = 0xffffff;
					data.backgroundColor = 0xADC6D1;
				}

				monthArr.push( data );
			}

			dateGroup.dataProvider = new ArrayList( monthArr );
		}

		protected function updateYearTypeContent( value:Date ):void
		{
			// 年份：4行3列
			var date:Date = new Date(); // 当前日期
			var itemWidth:Number = dateGroup.width / 3;
			var itemHeight:Number = dateGroup.height / 4;

			// 清除所有
			if( dateGroup.dataProvider )
				dateGroup.dataProvider.removeAll();

			// 当前选择的年份，或者今年放在第三行中间
			var selYear:Number = _date ? _date.fullYear : 0;
			var curYear:Number = date.fullYear;
			var yearArr:Array = [];

			startYear = value.fullYear - 7;
			endYear = value.fullYear + 4;

			// 表头信息
			setTitleContent( startYear + " - " + endYear );

			// 对应时间
			date.time = value.time;

			for( var i:int = startYear; i <= endYear; i++ )
			{
				date.fullYear = i;

				var data:DatePickerCellSet = new DatePickerCellSet();
				data.label = String( i );
				data.width = itemWidth;
				data.height = itemHeight;
				data.color = getStyle( "color" );
				data.time = date.time;

				if( i == curYear )
				{
					data.color = 0xADC6D1;
					data.bold = "bold";
				}

				if( i == selYear )
				{
					data.color = 0xffffff;
					data.backgroundColor = 0xADC6D1;
				}

				yearArr.push( data );
			}

			dateGroup.dataProvider = new ArrayList( yearArr );
		}

		/**
		 * 设置中心按钮的标签内容，相当于日期选择器的标题
		 * @param value
		 */
		protected function setTitleContent( value:String ):void
		{
			if( centerButton )
				centerButton.label = value;
		}

		/**
		 * 根据指定的格式，更新选定的内容
		 */
		protected function updateContentByFormat( dispatch:Boolean = true ):void
		{
			if( _date == null )
				return;

			/*
			Y - 4 位数字完整表示的年份：例如：1999 或 2003
			y - 2 位数字表示的年份：99 或 03
			M - 三个字母缩写表示的月份：Jan 到 Dec
			m - 数字表示的月份，有前导零的 2 位数字：01 到 12
			n - 数字表示的月份，没有前导零：1 到 12
			D - 星期中的第几天，文本表示，3 个字母：Mon 到 Sun
			d - 月份中的第几天，有前导零的 2 位数字：01 到 31
			j - 月份中的第几天，没有前导零：1 到 31
			*/
			var Y:String = String( _date.fullYear );
			var y:String = Y.substr( 2 );

			var M:String = MONTH_EN[ _date.month ];
			var n:String = String( _date.month + 1 );
			var m:String = "0" + n;
			m = m.substr( m.length - 2 );

			var D:String = WEEK_EN[ _date.day ];
			var j:String = String( _date.date );
			var d:String = "0" + j;
			d = d.substr( d.length - 2 );

			var r:String = format;
			r = r.replace( /Y/g, Y );
			r = r.replace( /y/g, y );
			r = r.replace( /M/g, M );
			r = r.replace( /m/g, m );
			r = r.replace( /n/g, n );
			r = r.replace( /D/g, D );
			r = r.replace( /d/g, d );
			r = r.replace( /j/g, j );

			if( dispatch && _dateString != r )
				dispatchEvent( new DatePickerEvent( "dateChanged" ));

			_dateString = r;

		}

		protected function changeValidTypes():void
		{
			var hasYear:Boolean = checkTypesInFormat( FORMAT_YEAR );
			var hasMonth:Boolean = checkTypesInFormat( FORMAT_MONTH );
			var hasDay:Boolean = checkTypesInFormat( FORMAT_DAY );

			var delTypes:Array = validTypes.splice( 0, validTypes.length );

			hasDay && validTypes.push( 0 );
			hasMonth && validTypes.push( 1 );
			hasYear && validTypes.push( 2 );

			var same:Boolean = delTypes.length == validTypes.length //
			&& delTypes[ 0 ] == validTypes[ 0 ] //
			&& delTypes[ 1 ] == validTypes[ 1 ] //
			&& delTypes[ 2 ] == validTypes[ 2 ];

			if( !same )
			{
				dateType = validTypes[ dateType ];
			}
		}

		//--------------------------------------------------------------------------
		//
		//	Renderer clicked
		//
		//--------------------------------------------------------------------------

		/**
		 * 当日期选择器中的某个单元格被点击时执行此方法
		 * @param renderer
		 */
		protected function rendererClicked( renderer:DataRenderer ):void
		{
			var time:Number = Number( renderer.data.time );

			_date = _date || new Date();

			switch( dateType )
			{
				case 1:
				{
					// 月内容
					monthSelected( time );
					break;
				}
				case 2:
				{
					// 年内容
					yearSelected( time );
					break;
				}
				default:
				{
					// 日内容
					daySelected( time );
				}
			}

			// 更新绑定内容
			if( txtInput )
				txtInput.text = dateString;
		}

		private function yearSelected( time:Number ):void
		{
			TMP_DATE.time = time;
			_date.fullYear = TMP_DATE.fullYear;

			if( checkTypesInFormat( FORMAT_MONTH ))
			{
				// 若日期格式中存在月份，则直接跳转到月份选择
				dateType = MONTH_TYPE;
			}
			else
			{
				_selectedTime = time;
				trace( "yearSelected", new Date( time ).toString());

				// 若不存在月份，则直接派发事件（结束选择）
				updateContentByFormat();

				// 日期单位选择事件
				dispatchChangeEvent( DatePickerEvent.SELECTED, _dateString );
			}
		}

		private function monthSelected( time:Number ):void
		{
			TMP_DATE.time = time;
			_date.fullYear = TMP_DATE.fullYear;
			_date.month = TMP_DATE.month;

			if( checkTypesInFormat( FORMAT_DAY ))
			{
				// 若日期格式中存在日期，则直接跳转到月份选择
				dateType = DAY_TYPE;
			}
			else
			{
				_selectedTime = time;
				trace( "monthSelected", new Date( time ).toString());

				// 若不存在日期，则直接派发事件（结束选择）
				updateContentByFormat();

				// 日期单位选择事件
				dispatchChangeEvent( DatePickerEvent.SELECTED, _dateString );
			}
		}

		private function daySelected( time:Number ):void
		{
			TMP_DATE.time = time;
			_date.fullYear = TMP_DATE.fullYear;
			_date.month = TMP_DATE.month;
			_date.date = TMP_DATE.date;

			_selectedTime = time;
			trace( "daySelected", new Date( time ).toString());

			// 派发事件，结束选择
			updateContentByFormat();

			// 日期单位选择事件
			dispatchChangeEvent( DatePickerEvent.SELECTED, _dateString );
		}

		/**
		 * 检测指定的类型在所设定的格式中是否存在
		 * @param types
		 * @return
		 */
		protected function checkTypesInFormat( types:Array ):Boolean
		{
			for each( var type:String in types )
			{
				if( format.indexOf( type ) != -1 )
					return true;
			}

			return false;
		}

		protected function dispatchChangeEvent( type:String, dateString:String = null ):void
		{
			if( hasEventListener( type ))
				dispatchEvent( new DatePickerEvent( type, dateString ));
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		protected function previousHandler():void
		{
			switch( dateType )
			{
				case 1:
				{
					// 月内容（切换到去年）
					_tmpDate.fullYear--;
					updateMonthTypeContent( _tmpDate );
					break;
				}
				case 2:
				{
					// 年内容（切换到上一页N个年份）
					_tmpDate.fullYear = startYear - 5;
					updateYearTypeContent( _tmpDate );
					break;
				}
				default:
				{
					// 日内容（切换到上个月）
					_tmpDate.month--;
					updateDayTypeContent( _tmpDate );
				}
			}
		}

		protected function nextHandler():void
		{
			switch( dateType )
			{
				case 1:
				{
					// 月内容（切换到明年）
					_tmpDate.fullYear++;
					updateMonthTypeContent( _tmpDate );
					break;
				}
				case 2:
				{
					// 年内容（切换到下一页N个年份）
					_tmpDate.fullYear = endYear + 8;
					updateYearTypeContent( _tmpDate );
					break;
				}
				default:
				{
					// 日内容（切换到下个月）
					_tmpDate.month++;
					updateDayTypeContent( _tmpDate );
				}
			}
		}

		protected function buttonClickHandler( event:MouseEvent ):void
		{
			switch( event.target )
			{
				case previousButton:
				{
					previousHandler();
					break;
				}
				case nextButton:
				{
					nextHandler();
					break;
				}
				case centerButton:
				{
					var curIndex:int = validTypes.indexOf( dateType );
					curIndex++;
					curIndex = curIndex == validTypes.length ? 0 : curIndex;
					dateType = validTypes[ curIndex ];
					break;
				}
				case clearButton:
				{
					clear();
					break;
				}
			}
		}

		private function dataGroupRendererHandler( event:RendererExistenceEvent ):void
		{
			if( event.type == RendererExistenceEvent.RENDERER_ADD )
			{
				( event.renderer as DataRenderer ).mouseChildren = false;
				event.renderer.addEventListener( MouseEvent.CLICK, rendererClickHandler );
			}
			else
			{
				event.renderer.removeEventListener( MouseEvent.CLICK, rendererClickHandler );
			}
		}

		protected function rendererClickHandler( event:MouseEvent ):void
		{
			event.stopPropagation();
			rendererClicked( event.target as DataRenderer );
		}

		private function weekGroupRendererAddHandler( event:RendererExistenceEvent ):void
		{
			var item:IR_DatePickerWeek = event.renderer as IR_DatePickerWeek;
			item.width = dateGroup.width / 7;
			item.height = weekGroup.height;
		}
	}
}
