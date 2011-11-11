package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialEnvMapping;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.test.BaseTest;
	import com.yogurt3d.test.CameraController;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.hires.debug.Stats;
	
	import skybox.*;
	
	[SWF(width="638", height="478", frameRate="60")]
	public class wikiEnvMapping extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiEnvMapping()
		{
			m_resourceManager = new ResourceManager();
			super();
			
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
				
				m_sceneObject.material = new MaterialEnvMapping(m_resourceManager.envMap);
				
				scene.addChild(m_resourceManager.getPlane());
				scene.addChild(m_sceneObject);
				scene.addChild(m_resourceManager.getStaticObj());
				scene.addChild(m_resourceManager.getAO());
				
				CameraController.moveRatio = m_resourceManager.moveRatio;
				createLights();
				setupTargetCamera();
				
				m_resourceManager.setDefaultCamera(camera);
				
				
				Yogurt3D.instance.startAutoUpdate();
				
			});
			m_loader.start();
			
		}
		
		private var window						:Window;
		private var normalCheckBox				:CheckBox;
		private var reflectivityCheckBox		:CheckBox;
		private var alphaSlider					:HSlider;
		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this, m_resourceManager.windowX, m_resourceManager.windowY,"EnvMapping Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			normalCheckBox = new CheckBox(window, 5, 5, "Normal Map",function(_e:Event):void{
				if(MaterialEnvMapping(m_sceneObject.material).normalMap == null){
					MaterialEnvMapping(m_sceneObject.material).normalMap = getMap("normalMap");
				}else{
					MaterialEnvMapping(m_sceneObject.material).normalMap = null;
				}
			});
			normalCheckBox.selected = false;
			
			reflectivityCheckBox = new CheckBox(window, 5, 20, "Reflectivity map",function(_e:Event):void{
				if(MaterialEnvMapping(m_sceneObject.material).reflectivityMap == null)
					MaterialEnvMapping(m_sceneObject.material).reflectivityMap = getMap("reflectionMap");
				else
					MaterialEnvMapping(m_sceneObject.material).reflectivityMap = null;
			});
			
			var alphaLabel:Label = new Label(window, 5, 35,"Opacity: 1");
			alphaSlider = new HSlider(window, 5, 50, function(_e:Event):void{
				alphaLabel.text = "Opacity: "+ alphaSlider.value;
				MaterialEnvMapping(m_sceneObject.material).opacity = alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			
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