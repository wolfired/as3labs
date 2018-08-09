package component.builtin {

	import component.Component;
	import component.ComponentRegister;

	public class URLLoaderComponent extends Component {
		public static const IDX:uint = ComponentRegister.register(URLLoaderComponent);

		public function URLLoaderComponent() {
			super();
		}
	}
}
