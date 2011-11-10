package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Slider;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialEnvMapFresnelSpecularTexture;
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
	public class wikiEnvMapFresnelSpecularTexture extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiEnvMapFresnelSpecularTexture()
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
				
				m_sceneObject.material = new MaterialEnvMapFresnelSpecularTexture(m_resourceManager.envMap,m_resourceManager.getMap("colorMap"),
					m_resourceManager.getMap("normalMap"),m_resourceManager.getMap("specularMap"),null, 0.5, 1);
				
				(m_sceneObject.material as MaterialEnvMapFresnelSpecularTexture).shininess = 0;
				m_sceneObject.material.ambientColor.setColorUint(0xFF1928);
				m_sceneObject.material.ambientColor.a = 0.73;
								
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
		private var normalCheckBox				:CheckBox;
		private var reflectivityCheckBox		:CheckBox;
		private var alphaSlider					:HSlider;
		private var fresnelX					:HSlider;
		private var fresnelY					:HSlider;
		
		private var frRef						:Label;
		private var frPow						:Label;
		private var refL						:Label;
		private var colorChooser				:ColorChooser;
		private var window2						:Window;
		private var window3						:Window;
		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this, m_resourceManager.windowX, m_resourceManager.windowY,"EnvMapFresnelSpecular Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			normalCheckBox = new CheckBox(window, 5, 5, "Normal Map",function(_e:Event):void{
				if(MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).normalMap == null)
					MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).normalMap = getMap("normalMap");
				else
					MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).normalMap = null;
				
			});
			normalCheckBox.selected = true;
			
			reflectivityCheckBox = new CheckBox(window, 5, 20, "Reflectivity map",function(_e:Event):void{
				if(MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).reflectivityMap == null)
					MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).reflectivityMap = getMap("reflectionMap");
				else
					MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).reflectivityMap = null;
			});
			
			var oLab:Label = new Label(window, 5, 35,"Opacity: 1");
			alphaSlider = new HSlider(window, 5, 50, function(_e:Event):void{
				MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).opacity = alphaSlider.value;
				oLab.text = "Opacity: "+alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			
			frRef = new Label(window, 5, 65,"Fresnel Reflectance:");
			fresnelX = new HSlider(window, 5, 80, function(_e:Event):void{
				MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).fresnelReflectance = fresnelX.value;
				frRef.text = "Fresnel Reflectance: "+ fresnelX.value;
			});
			fresnelX.maximum = 1;
			fresnelX.minimum = 0;
			fresnelX.value = MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).fresnelReflectance;
			frRef.text = "Fresnel Reflectance: "+ fresnelX.value;
			
			
			frPow = new Label(window, 5, 95,"Fresnel Power:");
			fresnelY = new HSlider(window, 5, 110, function(_e:Event):void{
				MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).fresnelPower = fresnelY.value;
				frPow.text = "Fresnel Power: "+ fresnelY.value;
			});			
			fresnelY.maximum = 7;
			fresnelY.minimum = 0;
			fresnelY.value = MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).fresnelPower;
			
			frPow.text = "Fresnel Power: "+ fresnelY.value;
			
			new Label(window,5,130,"Shininess");
			var slider4:Slider = new Slider( "horizontal", window, 5, 145, function():void{
				MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).shininess= slider4.value;
			});
			slider4.value = MaterialEnvMapFresnelSpecularTexture(m_sceneObject.material).shininess;
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