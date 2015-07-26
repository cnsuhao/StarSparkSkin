//------------------------------------------------------------------------------
//
// ...
// classname: Validator
// author: 喵大斯( blog.csdn.net/aosnowasp )
// created: 2015-7-26
// copyright (c) 2013 喵大斯( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.plugins
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import mx.core.IMXMLObject;
	import mx.events.ValidationResultEvent;
	import mx.validators.IValidator;
	import mx.validators.Validator;

	import starskin.events.ValidatorEvent;
	import starskin.namespaces.dx_internal;

	use namespace dx_internal;

	//----------------------------------------
	//  Event
	//----------------------------------------

	/** 当验证器通过验证时派发  **/
	[Event( name = "valid", type = "starskin.events.ValidatorEvent" )]

	/** 当验证器验证未通过时派发  **/
	[Event( name = "invalid", type = "starskin.events.ValidatorEvent" )]

	/** 当验证结果发生变化时派发  **/
	[Event( name = "validChanged", type = "starskin.events.ValidatorEvent" )]

	//----------------------------------------
	//  DefaultProperty
	//----------------------------------------

	/** 默认属性，这样就可以在 MXML 代码中将多个验证器包含在 Validator 标签中  **/
	[DefaultProperty( "validators" )]

	/**
	 * 表单批量自动验证框架
	 * <p>应用于 Form 中有多个验证器同时工作时，统一监测验证结果，而进行相应的逻辑处理。例：只有所有验证器都通过后，才能提交表单。</p>
	 * @author AoSnow
	 */
	public class FormValidator extends EventDispatcher implements IMXMLObject
	{

		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function FormValidator()
		{
			results = new Vector.<ValidationResultEvent>();
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		private var _id:String;

		public function get id():String
		{
			return _id;
		}

		private var _document:Object;

		public function get document():Object
		{
			return _document;
		}

		//----------------------------------------
		//  results
		//----------------------------------------

		dx_internal var results:Vector.<ValidationResultEvent>;

		//----------------------------------------
		//  valid
		//----------------------------------------

		private var _valid:Boolean;

		[Bindable( "validChanged" )]
		/**
		 * 所有验证器的验证结果是否通过
		 * @return
		 */
		public function get valid():Boolean
		{
			return _valid;
		}

		//----------------------------------------
		//  validators
		//----------------------------------------

		private var _validators:Array;

		/**
		 * 多个验证器的数组集合
		 * <p>数组元素必须是 Validator 对象，否则将被忽略。</p>
		 * @return
		 */
		public function get validators():Array
		{
			return _validators;
		}

		public function set validators( value:Array ):void
		{
			if( _validators && _validators.length > 0 )
				throw new ArgumentError( "验证器已经指定，若需要重新指定验证器集合，请先执行 reset 重置验证器。" );

			_validators = value;
			_numRequired = 0;
			_numValidRequired = 0;

			var lng:int = value.length;
			var validator:Validator;

			for( var i:int = 0; i < lng; i++ )
			{
				validator = value[ i ] as Validator;

				if( validator )
				{
					if( validator.required )
						_numRequired++;

					validator.addEventListener( ValidationResultEvent.INVALID, validationResultHandler );
					validator.addEventListener( ValidationResultEvent.VALID, validationResultHandler );
				}
			}
		}

		//----------------------------------------
		//  numRequired
		//----------------------------------------

		private var _numRequired:int;

		/**
		 * 强制填写不能为空的验证器的数量
		 * @return
		 */
		public function get numRequired():int
		{
			return _numRequired;
		}

		//----------------------------------------
		//  required
		//----------------------------------------

		/**
		 * 验证器是否有需要强制验证的项目
		 * @return
		 */
		public function get required():Boolean
		{
			return _numRequired > 0;
		}

		//----------------------------------------
		//  numValidRequired
		//----------------------------------------

		private var _numValidRequired:int;

		/**
		 * 强制填写的验证器已经通过验证的数量
		 * @return
		 */
		public function get numValidRequired():int
		{
			return _numValidRequired;
		}

		//----------------------------------------
		//  numValidator
		//----------------------------------------

		/**
		 * 验证器的总数量
		 * @return
		 */
		public function get numValidator():int
		{
			return _validators ? _validators.length : 0;
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		public function initialized( document:Object, id:String ):void
		{
			_id = id;
			_document = document;
		}

		public function reset():void
		{
			_valid = false;
			_numRequired = 0;
			_numValidRequired = 0;

			var num:int = numValidator;

			if( num > 0 )
			{
				var validator:Validator;

				for( var i:int = 0; i < num; i++ )
				{
					validator = _validators[ i ] as Validator;
					validator.removeEventListener( ValidationResultEvent.INVALID, validationResultHandler );
					validator.removeEventListener( ValidationResultEvent.VALID, validationResultHandler );
				}

				_validators.length = 0;
				_validators = null;
			}
		}

		/**
		 * 当验证器结果发生变化时，更新 FormValidator 的结果
		 * @param event
		 */
		protected function updateValidResult( event:ValidationResultEvent ):void
		{
			var lng:int = results.length;
			var cur:ValidationResultEvent;
			var validator:Validator;
			var valid:Boolean = true;
			var numValid:int = 0; // 已经验证通过的项目，包括 required 项目

			_numValidRequired = 0;

			for( var i:int = 0; i < lng; i++ )
			{
				cur = results[ i ];
				validator = cur.currentTarget as Validator;
				numValid += cur.type == ValidationResultEvent.VALID ? 1 : 0;

				if( validator.required )
				{
					_numValidRequired += cur.type == ValidationResultEvent.VALID ? 1 : 0;
				}

				// 任何一个验证器未通过，结果都失败。即使不是强制验证项目
				if( cur.type == ValidationResultEvent.INVALID )
				{
					valid = false;
					break;
				}
			}

			// 若所有结果的检测都正确，再检测是否填写所有强制项目
			if( valid )
			{
				valid = _numValidRequired == _numRequired;
			}

			// 事件派发验证
			if( valid != _valid )
			{
				_valid = valid;
				dispatchEvent( new ValidatorEvent( ValidatorEvent.VALID_CHANGED, _valid ));
			}

			if( hasEventListener( ValidatorEvent.VALID ) && valid )
				dispatchEvent( new ValidatorEvent( ValidatorEvent.VALID, _valid ));

			if( hasEventListener( ValidatorEvent.INVALID ) && !valid )
				dispatchEvent( new ValidatorEvent( ValidatorEvent.INVALID, _valid ));
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		protected function validationResultHandler( event:ValidationResultEvent ):void
		{
			var alreadyIn:Boolean = false;

			for( var i:int = 0; i < results.length; i++ )
			{
				// 比较发出事件的目标源
				if( results[ i ].currentTarget == event.currentTarget )
				{
					results[ i ] = event;
					alreadyIn = true;
					break;
				}
			}

			if( !alreadyIn )
			{
				results.push( event );
			}

			// 更新验证结果
			updateValidResult( event );
		}
	}
}
