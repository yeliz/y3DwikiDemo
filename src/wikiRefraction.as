package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialRefraction;
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
	public class wikiRefraction extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiRefraction()
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
				
				m_sceneObject.material = new MaterialRefraction(m_resourceManager.envMap,0xFFFFFF, 
					0.74, null, null, 1.0, true, 0.1, 2);
				
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
		private var fresnelCheckBox				:CheckBox;
		private var reflectivityCheckBox		:CheckBox;
		private var alphaSlider					:HSlider;
		private var refSlider					:HSlider;
		private var fresnelX					:HSlider;
		private var fresnelY					:HSlider;
		
		private var frRef						:Label;
		private var frPow						:Label;
		private var refL						:Label;
		private var colorChooser				:ColorChooser;

		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this,  m_resourceManager.windowX, m_resourceManager.windowY,"Refraction Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			normalCheckBox = new CheckBox(window, 5, 5, "Normal Map",function(_e:Event):void{
				if(MaterialRefraction(m_sceneObject.material).normalMap == null)
					MaterialRefraction(m_sceneObject.material).normalMap = getMap("normalMap");
				else
					MaterialRefraction(m_sceneObject.material).normalMap = null;
			
			});
			normalCheckBox.selected = false;
			
			reflectivityCheckBox = new CheckBox(window, 5, 20, "Reflectivity map",function(_e:Event):void{
				if(MaterialRefraction(m_sceneObject.material).refractivityMap == null)
					MaterialRefraction(m_sceneObject.material).refractivityMap = getMap("reflectionMap");
				else
					MaterialRefraction(m_sceneObject.material).refractivityMap = null;
			});
			
			var oLab:Label = new Label(window, 5, 30,"Opacity: 1");
			alphaSlider = new HSlider(window, 5, 45, function(_e:Event):void{
				MaterialRefraction(m_sceneObject.material).opacity = alphaSlider.value;
				oLab.text = "Opacity: "+alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			
			refL = new Label(window, 5, 55,"Refractive Index");
			refSlider = new HSlider(window, 5, 70, function(_e:Event):void{
				MaterialRefraction(m_sceneObject.material).refIndex = refSlider.value;
				refL.text = "Refractive Index: "+ refSlider.value;
			});
			refSlider.maximum = 2;
			refSlider.minimum = -1;
			refSlider.value = 0.84;
	
			refL.text = "Refractive Index: "+ refSlider.value;
			
			fresnelCheckBox = new CheckBox(window, 5, 83, "hasFresnel",function(_e:Event):void{
				MaterialRefraction(m_sceneObject.material).hasFresnel = fresnelCheckBox.selected;
			});
			fresnelCheckBox.selected = true;
			
			frRef = new Label(window, 5, 93,"Fresnel Reflectance:");
			fresnelX = new HSlider(window, 5, 108, function(_e:Event):void{
				MaterialRefraction(m_sceneObject.material).fresnelReflectance = fresnelX.value;
				frRef.text = "Fresnel Reflectance: "+ fresnelX.value;
			});
			fresnelX.maximum = 1;
			fresnelX.minimum = 0;
			fresnelX.value = 0.1;
			frRef.text = "Fresnel Reflectance: "+ fresnelX.value;
			
						
			frPow = new Label(window, 5, 123,"Fresnel Power:");
			fresnelY = new HSlider(window, 5, 138, function(_e:Event):void{
				MaterialRefraction(m_sceneObject.material).fresnelPower = fresnelY.value;
				frPow.text = "Fresnel Power: "+ fresnelY.value;
			});			
			fresnelY.maximum = 7;
			fresnelY.minimum = 0;
			fresnelY.value = 2.0;
			
			frPow.text = "Fresnel Power: "+ fresnelY.value;
			
			var c1Label:Label = new Label(window, 5, 148,"Color");
			colorChooser = new ColorChooser( window, 5, 163, 0xFFFFFF, function(_e:Event):void{
				MaterialRefraction(m_sceneObject.material).color =  colorChooser.value;
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