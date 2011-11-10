package
{
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialFill;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.test.BaseTest;
	import com.yogurt3d.test.CameraController;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import skybox.*;
	
	[SWF(width="638", height="478", frameRate="60")]
	public class wikiFill extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiFill()
		{
			super();
			
			m_resourceManager = new ResourceManager();
			
		}
		
		public function createLights():void{
			
			m_light = m_resourceManager.createLight();
			scene.addChild( m_light );		
		}
		private function getMap(_key:String):TextureMap{
			
			return m_resourceManager.getMap(_key );
		}
		
		public override function createSceneObjects(e:Event = null):void{
			
			m_resourceManager.loadResources();
			m_loader = m_resourceManager.loader;
			
			m_loader.addEventListener( LoaderEvent.ALL_COMPLETE, function( _e:LoaderEvent ):void
			{
				if(m_resourceManager.includeUI)
					createUI();
				
				//scene.skyBox = new NightSkyBox;
				scene.sceneColor = m_resourceManager.sceneColor;
				
				m_sceneObject 				= m_resourceManager.getObject();
				
				m_sceneObject.material =  new MaterialFill(0xFF0000);
				
				scene.addChild(m_resourceManager.getPlane());
				scene.addChild(m_sceneObject);
				scene.addChild(m_resourceManager.getStaticObj());
				
				CameraController.moveRatio = m_resourceManager.moveRatio;
				createLights();
				setupTargetCamera();
				
				m_resourceManager.setDefaultCamera(camera);
				
				Yogurt3D.instance.startAutoUpdate();
				
			});
			m_loader.start();
			
		}
	
		private var window						:Window;
		private var alphaSlider					:HSlider;
		private var colorChooser				:ColorChooser;
		private var alphaLabel					:Label;
		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this, m_resourceManager.windowX, m_resourceManager.windowY,"Fill Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			alphaLabel = new Label(window, 5, 15,"Opacity");
			alphaSlider = new HSlider(window, 5, 30, function(_e:Event):void{
				MaterialFill(m_sceneObject.material).opacity = alphaSlider.value;
				alphaLabel.text = "Opacity: "+ alphaSlider.value;
			});
			
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			alphaLabel.text = "Opacity: "+ alphaSlider.value;
			
			
			new Label(window, 5, 45,"Fill Color");
			colorChooser = new ColorChooser( window, 5, 65, 0xFFFFFF, function(_e:Event):void{
				MaterialFill(m_sceneObject.material).color =  colorChooser.value;
			});
			colorChooser.usePopup = true;
			
		}
	
		protected function onMouseOut(event:Event):void{
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, CameraController.onMouseMove);	
		}
		
		protected function onWindowSelect(event:Event):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, CameraController.onMouseMove);
		}
		
	}
}