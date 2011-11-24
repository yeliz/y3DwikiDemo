package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialEnvMapFresnel;
	import com.yogurt3d.core.materials.base.Color;
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
	public class wikiEnvMapFresnel extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiEnvMapFresnel()
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
			
			showLoader();
			
			m_loader.addEventListener( LoaderEvent.LOAD_PROGRESS, function( _e:LoaderEvent ):void{
				var path:String = _e.loader.loadPath;
				path = path.substr( path.lastIndexOf("/")+1 );
				setLoaderData( _e.bytesLoaded / _e.bytesTotal * 100, "Loading " + path + " ... \t\t("+Math.round(_e.bytesLoaded/1024)+"KB/"+ Math.round(_e.bytesTotal/1024) +"KB)" );
			});
			
			m_loader.addEventListener( LoaderEvent.ALL_COMPLETE, function( _e:LoaderEvent ):void
			{
				//scene.skyBox = new NightSkyBox;
				scene.sceneColor = m_resourceManager.sceneColor;
				
				m_sceneObject 				= m_resourceManager.getObject();
				
				m_sceneObject.material = new MaterialEnvMapFresnel(m_resourceManager.envMap,null,
					null,null,0.3,2, 1, 1);
				m_sceneObject.material.ambientColor = new Color(0.90, 0.24, 0.36, 0.7);
				
				scene.addChild(m_resourceManager.getPlane());
				scene.addChild(m_sceneObject);
				scene.addChild(m_resourceManager.getStaticObj());
				scene.addChild(m_resourceManager.getAO());
				
				if(m_resourceManager.includeUI)
					createUI();
				
				CameraController.moveRatio = m_resourceManager.moveRatio;
				createLights();
				setupTargetCamera();
				
				m_resourceManager.setDefaultCamera(camera);
				
				
				Yogurt3D.instance.startAutoUpdate();
				hideLoader();
				
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
			
			window = new Window(this, m_resourceManager.windowX, m_resourceManager.windowY,"EnvMapFresnel Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			normalCheckBox = new CheckBox(window, 5, 5, "Normal Map",function(_e:Event):void{
				if(MaterialEnvMapFresnel(m_sceneObject.material).normalMap == null)
					MaterialEnvMapFresnel(m_sceneObject.material).normalMap = getMap("normalMap");
				else
					MaterialEnvMapFresnel(m_sceneObject.material).normalMap = null;
				
			});
			normalCheckBox.selected = false;
			
			reflectivityCheckBox = new CheckBox(window, 5, 20, "Reflectivity map",function(_e:Event):void{
				if(MaterialEnvMapFresnel(m_sceneObject.material).reflectivityMap == null)
					MaterialEnvMapFresnel(m_sceneObject.material).reflectivityMap = getMap("reflectionMap");
				else
					MaterialEnvMapFresnel(m_sceneObject.material).reflectivityMap = null;
			});
			
			var oLab:Label = new Label(window, 5, 35,"Opacity: 1");
			alphaSlider = new HSlider(window, 5, 50, function(_e:Event):void{
				MaterialEnvMapFresnel(m_sceneObject.material).opacity = alphaSlider.value;
				oLab.text = "Opacity: "+alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			
			frRef = new Label(window, 5, 65,"Fresnel Reflectance:");
			fresnelX = new HSlider(window, 5, 80, function(_e:Event):void{
				MaterialEnvMapFresnel(m_sceneObject.material).fresnelReflectance = fresnelX.value;
				frRef.text = "Fresnel Reflectance: "+ fresnelX.value;
			});
			fresnelX.maximum = 1;
			fresnelX.minimum = 0;
			fresnelX.value = MaterialEnvMapFresnel(m_sceneObject.material).fresnelReflectance;
			frRef.text = "Fresnel Reflectance: "+ fresnelX.value;
			
			
			frPow = new Label(window, 5, 95,"Fresnel Power:");
			fresnelY = new HSlider(window, 5, 110, function(_e:Event):void{
				MaterialEnvMapFresnel(m_sceneObject.material).fresnelPower = fresnelY.value;
				frPow.text = "Fresnel Power: "+ fresnelY.value;
			});			
			fresnelY.maximum = 7;
			fresnelY.minimum = 1;
			fresnelY.tick = 1;
			fresnelY.value = MaterialEnvMapFresnel(m_sceneObject.material).fresnelPower;
			
			frPow.text = "Fresnel Power: "+ fresnelY.value;
			
			window3 = m_resourceManager.getMaterialDiffuseUI(this.scene, this, m_sceneObject.material);
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