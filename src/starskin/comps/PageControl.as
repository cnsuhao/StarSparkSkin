//------------------------------------------------------------------------------
//
// ...
// classname: PageControl
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-21
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.comps
{
	import flash.events.MouseEvent;

	import mx.collections.ArrayList;
	import mx.events.FlexEvent;

	import spark.components.ButtonBar;
	import spark.components.DataGroup;
	import spark.components.TextInput;
	import spark.components.supportClasses.ButtonBase;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	import spark.events.IndexChangeEvent;

	import starskin.events.PageControlEvent;
	import starskin.namespaces.dx_internal;

	use namespace dx_internal;

	/** 当页码发生改变时派发  **/
	[Event( name = "PageControlEvent_Index_Changed", type = "starskin.events.PageControlEvent" )]

	public class PageControl extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function PageControl()
		{
			super();

			// 未设置数据数量时，初始无效
			enabled = false;
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		[SkinPart( required = "false" )]
		/** 首页按钮  **/
		public var firstButton:ButtonBase;

		[SkinPart( required = "false" )]
		/** 上一页按钮  **/
		public var previousButton:ButtonBase;

		[SkinPart( required = "false" )]
		/** 下一页按钮  **/
		public var nextButton:ButtonBase;

		[SkinPart( required = "false" )]
		/** 尾页按钮  **/
		public var lastButton:ButtonBase;

		[SkinPart( required = "false" )]
		/** 跳转页面输入框  **/
		public var jumpTextInput:TextInput;

		[SkinPart( required = "false" )]
		/** 页面相关信息  **/
		public var pageInfo:TextBase;

		[SkinPart( required = "false" )]
		/** 页码列表容器  **/
		public var pageButtonBar:ButtonBar;

		//----------------------------------------
		//  page
		//----------------------------------------

		private var _pageIndex:int;
		private var _pageIndexChanged:Boolean;
		private var _needChangeIndexAfterPageListChanged:Boolean;

		/**
		 * 当前页码
		 * @return
		 */
		public function get pageIndex():int
		{
			return _pageIndex;
		}

		public function set pageIndex( value:int ):void
		{
			if( _pageIndex == value )
				return;

			_pageIndex = value;
			_pageIndexChanged = true;
			invalidateProperties();
		}

		//----------------------------------------
		//  pageSize
		//----------------------------------------

		private var _pageSize:int;
		private var _pageSizeChanged:Boolean;

		/**
		 * 每页显示多少条记录
		 * @return
		 */
		public function get pageSize():int
		{
			return _pageSize;
		}

		public function set pageSize( value:int ):void
		{
			if( _pageSize == value )
				return;
			_pageSize = value;
			_pageSizeChanged = true;
			invalidateProperties();
		}

		//----------------------------------------
		//  pageCount
		//----------------------------------------

		private var _pageCount:int;

		/**
		 * 总页数
		 * @return
		 */
		public function get pageCount():int
		{
			return _pageCount;
		}

		//----------------------------------------
		//  dataCount
		//----------------------------------------

		private var _dataCount:int;
		private var _dataCountChanged:Boolean;

		/**
		 * 数据记录的总数量
		 * <p>组件会依据 dataCount 及 pageSize 来计算总页数</p>
		 * @return
		 */
		public function get dataCount():int
		{
			return _dataCount;
		}

		public function set dataCount( value:int ):void
		{
			if( _dataCount == value )
				return;
			_dataCount = value;
			_dataCountChanged = true;
			invalidateProperties();
		}

		//----------------------------------------
		//  maxShowPage
		//----------------------------------------

		private var _maxShowPage:int = 8;
		private var _maxShowPageChanged:Boolean;

		/**
		 * 页码列表区最大显示的页码数量
		 * <p>当数据量过大，页数可能达到几十、几百，这将严重影响视觉效果，即使创建了也看不到所有的页码按钮，
		 * 因为它们必将扩展到屏幕以外，这时就可以通过设置最大显示的页码来动态显示最近范围内的页码。</p>
		 *
		 * <b>默认值：</b>8
		 * @return
		 */
		public function get maxShowPage():int
		{
			return _maxShowPage;
		}

		public function set maxShowPage( value:int ):void
		{
			if( _maxShowPage == value )
				return;
			_maxShowPage = value;
			_maxShowPageChanged = true;
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

			if( instance is TextInput )
			{
				( instance as TextInput ).addEventListener( FlexEvent.ENTER, textInputEnterHandler );
			}

			if( instance == pageButtonBar )
			{
				pageButtonBar.addEventListener( IndexChangeEvent.CHANGING, pageButtonClickHandler );
				pageButtonBar.addEventListener( IndexChangeEvent.CHANGE, pageButtonClickHandler );
			}
		}

		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );

			if( instance is ButtonBase )
			{
				( instance as ButtonBase ).removeEventListener( MouseEvent.CLICK, buttonClickHandler );
			}

			if( instance is TextInput )
			{
				( instance as TextInput ).removeEventListener( FlexEvent.ENTER, textInputEnterHandler );
			}

			if( instance == pageButtonBar )
			{
				pageButtonBar.removeEventListener( IndexChangeEvent.CHANGING, pageButtonClickHandler );
				pageButtonBar.removeEventListener( IndexChangeEvent.CHANGE, pageButtonClickHandler );
			}
		}

		override protected function commitProperties():void
		{
			super.commitProperties();

			var index:int = _pageIndex;
			var indexChanged:Boolean;

			index = index > pageCount ? pageCount : index;
			index = index < 1 ? 1 : index;
			indexChanged = _pageIndex != index;
			_pageIndex = index;

			if( _pageSizeChanged || _dataCountChanged || _maxShowPageChanged )
			{
				// 更新总页数
				_pageCount = Math.ceil( _dataCount / _pageSize );
				enabled = _pageCount > 0;
			}

			if( _pageSizeChanged || _dataCountChanged || _maxShowPageChanged || _pageIndexChanged || ( indexChanged && _pageCount > 0 ))
			{
				// 更新页码到指定数量
				setPageNumberList( _pageCount );

				// 设置其它按钮可点击与否
				updateControlButtonEnabled();

				// 通过按钮标签修正选中页码
				setSelectedIndexByLabel( index );

				// 更新设置分页信息
				setPageInfo( index );
			}

			// 重置标志
			_pageSizeChanged = _dataCountChanged = _pageIndexChanged = _maxShowPageChanged = false;
		}

		protected function updateControlButtonEnabled():void
		{
			firstButton.enabled = _pageIndex > 1;
			previousButton.enabled = _pageIndex > 1;
			nextButton.enabled = _pageIndex < _pageCount;
			lastButton.enabled = _pageIndex < _pageCount;
		}

		protected function setSelectedIndexByLabel( pageIndex:int ):void
		{
			var lng:int = pageButtonBar.dataProvider.length;

			for( var i:int = 0; i < lng; i++ )
			{
				if( pageButtonBar.dataProvider.getItemAt( i ) == pageIndex )
				{
					pageButtonBar.selectedIndex = i;

					// 派发页面更改事件
					dispatchPageChangedEvent( pageIndex );
					return;
				}
			}
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		protected function setPageInfo( pageIndex:int ):void
		{
			pageInfo.text = pageIndex + "/" + _pageCount + "，共 " + _dataCount + " 条数据"
		}

		protected function setPageNumberList( pageCount:int ):void
		{
			pageButtonBar.dataProvider = createPageArrayList( pageCount, maxShowPage );
			//pageButtonBar.validateNow();
		}

		protected function createPageArrayList( pageCount:int, maxShowPage:int ):ArrayList
		{
			maxShowPage = maxShowPage > pageCount ? pageCount : maxShowPage;

			var offset:int = Math.floor( maxShowPage / 2 );
			var start:int = pageIndex - offset;
			var end:int = pageIndex + offset - ( maxShowPage % 2 > 0 ? 0 : 1 );

			if( start < 1 )
			{
				// start - 1结果为负数，end 减这个负数实际上是向后扩展页码
				end -= start - 1;
				start = 1;
			}

			if( end > pageCount )
			{
				// 同上，向前扩展页码
				start -= end - pageCount;
				end = pageCount;
			}

			// 扩展页码后，控制边界
			var tagStart:int = start < 1 ? 1 : start;
			var tagEnd:int = end > pageCount ? pageCount : end;
			var tagArr:Array = [];

			for( var i:int = tagStart; i <= tagEnd; i++ )
			{
				tagArr.push( String( i ));
			}

			return new ArrayList( tagArr );
		}

		protected function updatePageArrayList( pageCount:int ):void
		{
			var length:int = pageButtonBar.dataProvider.length;
			var i:int;

			if( length != pageCount )
			{
				if( length > pageCount )
				{
					// 页码有多余数量，直接将多余的存入缓存池
					for( i = pageCount; i < length; i++ )
					{
						pageButtonBar.dataProvider.removeItemAt( i );
					}
				}
				else
				{
					// 页码数量不足，创建新的页码或者从缓存池取出
					for( i = length + 1; i <= pageCount; i++ )
					{
						pageButtonBar.dataProvider.addItem( String( i ));
					}
				}
			}
		}

		protected function dispatchPageChangedEvent( newPageIndex:int ):void
		{
			// 派发页面更改事件
			if( hasEventListener( PageControlEvent.CHANGED ))
			{
				dispatchEvent( new PageControlEvent( PageControlEvent.CHANGED, newPageIndex ));
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		protected function buttonClickHandler( event:MouseEvent ):void
		{
			switch( event.target )
			{
				case firstButton:
				{
					// 返回首页
					pageIndex = 1;
					break;
				}
				case previousButton:
				{
					// 返回上一页
					pageIndex -= 1;
					break;
				}
				case nextButton:
				{
					// 跳到下一页
					pageIndex += 1;
					break;
				}
				case lastButton:
				{
					// 跳到最后一页
					pageIndex = pageCount;
					break;
				}
			}
		}

		protected function pageButtonClickHandler( event:IndexChangeEvent ):void
		{
			var newPageIndex:int = int( pageButtonBar.dataProvider.getItemAt( event.newIndex ));

			if( event.type == IndexChangeEvent.CHANGING )
			{
				// 默认跳转到指定页
				_pageIndex = newPageIndex;

				// 更新页码
				setPageNumberList( pageCount );

				// 是否在改变页码列表后，需要修正当前选中的页码
				// 因为在更新页码后，有可能之前选中的页码已经易位到其它 selectedIndex 位置了
				_needChangeIndexAfterPageListChanged = newPageIndex != int( pageButtonBar.dataProvider.getItemAt( event.newIndex ));
			}
			else
			{
				// 设置其它按钮可点击与否
				updateControlButtonEnabled();

				// 跳转页面后，有可能由于页码范围变化，导致当前选中的页码与 _pageIndex 不一致，得重新检测并设置页码
				if( _needChangeIndexAfterPageListChanged )
				{
					_needChangeIndexAfterPageListChanged = false;

					// 通过按钮标签修正选中页码
					setSelectedIndexByLabel( _pageIndex );
				}
				else
				{
					// 派发页面更改事件
					dispatchPageChangedEvent( newPageIndex );
				}
			}
		}

		protected function textInputEnterHandler( event:FlexEvent ):void
		{
			pageIndex = int( jumpTextInput.text );
		}
	}
}
