package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Slider;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialEnvMappingSpecular;
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
	public class wikiEnvMappingSpecular extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiEnvMappingSpecular()
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
				
				m_sceneObject 				= m_resourceManager.getObject();
				
				m_sceneObject.material = new MaterialEnvMappingSpecular(
					m_resourceManager.envMap,getMap("colorMap"),
					getMap("normalMap"),
					getMap("specularMap"),null,0.43);
				
				(m_sceneObject.material as MaterialEnvMappingSpecular).shininess = 0;
				
				m_sceneObject.material.diffuseColor.setColorUint(0xFF8181);
				m_sceneObject.material.diffuseColor.a = 1.0;
				
				m_sceneObject.material.ambientColor.setColorUint(0xFF8F3D);
				m_sceneObject.material.ambientColor.a = 1.0;
				
				(m_sceneObject.material as MaterialEnvMappingSpecular).specularColor.setColorUint(0xA223FF);
				(m_sceneObject.material as MaterialEnvMappingSpecular).specularColor.a = 0.47;
				
				if(m_resourceManager.includeUI)
					createUI();
				
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
		private var normalCheckBox				:CheckBox;
		private var reflectivityCheckBox		:CheckBox;
		private var alphaSlider					:HSlider;
		
		private var window2						:Window;
		private var window3						:Window;
		private var xSlider						:HSlider;
		private var ySlider						:HSlider;
		private var zSlider						:HSlider;
		private var cCombo						:ComboBox;
		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this,  m_resourceManager.windowX, m_resourceManager.windowY,"EnvMapSpec Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			normalCheckBox = new CheckBox(window, 5, 5, "Normal Map",function(_e:Event):void{
				if(MaterialEnvMappingSpecular(m_sceneObject.material).normalMap == null){
					MaterialEnvMappingSpecular(m_sceneObject.material).normalMap = getMap("normalMap");
				}else{
					MaterialEnvMappingSpecular(m_sceneObject.material).normalMap = null;
				}
			});
			normalCheckBox.selected = true;
			
			reflectivityCheckBox = new CheckBox(window, 5, 20, "Reflectivity map",function(_e:Event):void{
				if(MaterialEnvMappingSpecular(m_sceneObject.material).reflectivityMap == null){
					MaterialEnvMappingSpecular(m_sceneObject.material).reflectivityMap = getMap("reflectionMap");
				}else{
					MaterialEnvMappingSpecular(m_sceneObject.material).reflectivityMap = null;
				}
			});
			
			var alphaLabel:Label = new Label(window, 5, 35,"Opacity:"+m_sceneObject.material.opacity);
			alphaSlider = new HSlider(window, 5, 50, function(_e:Event):void{
				MaterialEnvMappingSpecular(m_sceneObject.material).opacity = alphaSlider.value;
				alphaLabel.text = "Opacity: "+ alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = m_sceneObject.material.opacity;
			
			var alphaLab:Label = new Label(window, 5, 70,"Env Alpha:"+MaterialEnvMappingSpecular(m_sceneObject.material).alpha);
			var aSlider:HSlider = new HSlider(window, 5, 85, function(_e:Event):void{
				MaterialEnvMappingSpecular(m_sceneObject.material).alpha = aSlider.value;
				alphaLab.text = "Env Alpha: "+ aSlider.value;
			});
			aSlider.maximum = 1;
			aSlider.minimum = 0;
			aSlider.value = MaterialEnvMappingSpecular(m_sceneObject.material).alpha;
			
			new Label(window,5,100,"Shininess");
			var slider4:Slider = new Slider( "horizontal", window, 5, 120, function():void{
				MaterialEnvMappingSpecular(m_sceneObject.material).shininess= slider4.value;
			});
			slider4.value = MaterialEnvMappingSpecular(m_sceneObject.material).shininess;
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
		
		private function onDropAlpha(_e:Event):void{
			MaterialEnvMappingSpecular(m_sceneObject.material).opacity = alphaSlider.value;
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