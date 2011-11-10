package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Slider;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialSpecularFill;
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
	public class wikiSpecularFill extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiSpecularFill()
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
				//scene.skyBox = new NightSkyBox;
				scene.sceneColor = m_resourceManager.sceneColor;
				
				m_sceneObject 				=  m_resourceManager.getObject();
				
				m_sceneObject.material =  new MaterialSpecularFill(0xFFFFFF);
				
				scene.addChild(m_resourceManager.getPlane());
				scene.addChild(m_sceneObject);
				scene.addChild(m_resourceManager.getStaticObj());
				
				if(m_resourceManager.includeUI)
					createUI();
				
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
		private var window2						:Window;
		private var window3						:Window;
		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this, m_resourceManager.windowX, m_resourceManager.windowY,"SpecularFill Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			alphaLabel = new Label(window, 5, 15,"Opacity");
			alphaSlider = new HSlider(window, 5, 30, function(_e:Event):void{
				alphaLabel.text = "Opacity: "+ alphaSlider.value;
				MaterialSpecularFill(m_sceneObject.material).opacity = alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			alphaLabel.text = "Opacity: "+ alphaSlider.value;
			
			
			var c1Label:Label = new Label(window, 5, 45,"Color");
			colorChooser = new ColorChooser( window, 5, 60, 0xFFFFFF, function(_e:Event):void{
				MaterialSpecularFill(m_sceneObject.material).color =  colorChooser.value;
			});
			colorChooser.usePopup = true;
			
			new CheckBox(window, 5, 78, "Normal map",function(_e:Event):void{
				if(MaterialSpecularFill(m_sceneObject.material).normalMap == null){
					MaterialSpecularFill(m_sceneObject.material).normalMap = getMap("normalMap");
				}else{
					MaterialSpecularFill(m_sceneObject.material).normalMap = null;
				}
			});
			
			new Label(window,5,90,"Shininess");
			var slider4:Slider = new Slider( "horizontal", window, 5, 105, function():void{
				MaterialSpecularFill(m_sceneObject.material).shininess= slider4.value;
			});
			slider4.value = MaterialSpecularFill(m_sceneObject.material).shininess;
			slider4.minimum = 5;
			slider4.maximum = 250;
			
	
			window3 = m_resourceManager.getMaterialSpecularUI(this.scene, this, m_sceneObject.material);
			window3.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window3.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window3.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			window2 = m_resourceManager.getLightUI(this.scene, this);
			window2.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window2.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window2.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);	
			
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