package idiot.pool {

	import flash.utils.Dictionary;

	SWITCH::debug {
		import flash.utils.describeType;
		import flash.utils.getQualifiedClassName;
	}

	public final class Pool {
		private static const _ins:Pool = new Pool();

		public static function get ins():Pool {
			return _ins;
		}

		public function Pool() {
		}

		private const _clazz_dict:Dictionary = new Dictionary();
		private const _ins_dict:Dictionary = new Dictionary();

		/**
		 * 从对象池取出对象
		 * @param clazz
		 * @return
		 * @see IPoolable
		 */
		public function pull(clazz:Class):IPoolable {
			SWITCH::debug {
				const full_name:String = getQualifiedClassName(IPoolable);

				const dt:XML = describeType(clazz);

				const implementsInterfaces:XMLList = dt.factory[0].implementsInterface as XMLList;

				var implemented:Boolean = false;

				for each(var implementsInterface:XML in implementsInterfaces) {
					implemented = full_name == implementsInterface.@type;

					if(implemented) {
						break;
					}
				}

				if(!implemented) {
					throw new Error("have to implements " + full_name);
				}
			}

			var pools:Vector.<IPoolable> = _clazz_dict[clazz] as Vector.<IPoolable>;

			if(null == pools) {
				_clazz_dict[clazz] = pools = new Vector.<IPoolable>();
			}

			var ins:IPoolable;

			if(0 == pools.length) {
				ins = new clazz() as IPoolable;
				_ins_dict[ins] = pools;
			} else {
				ins = pools.pop();
			}

			ins.reset();

			return ins;
		}

		/**
		 * 把对象放加对象池
		 * @param ins
		 * @see IPoolable
		 */
		public function push(ins:IPoolable):void {
			SWITCH::debug {
				const full_name:String = getQualifiedClassName(IPoolable);

				const dt:XML = describeType(ins);

				const implementsInterfaces:XMLList = dt.implementsInterface as XMLList;

				var implemented:Boolean = false;

				for each(var implementsInterface:XML in implementsInterfaces) {
					implemented = full_name == implementsInterface.@type;

					if(implemented) {
						break;
					}
				}

				if(!implemented) {
					throw new Error("have to implements " + full_name);
				}
			}

			const pools:Vector.<IPoolable> = _ins_dict[ins] as Vector.<IPoolable>;
			pools.push(ins);
		}
	}
}
