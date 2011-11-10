package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialTwoColorFresnel;
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
	public class wikiTwoColor extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiTwoColor()
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
				//scene.skyBox = new NightSkyBox;
				scene.sceneColor = m_resourceManager.sceneColor;
				
				m_sceneObject 				= m_resourceManager.getObject();
				
				m_sceneObject.material = new MaterialTwoColorFresnel(0xFF0000, 0x0000FF, 0.2, 2, 1);
				
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
		private var refSlider					:HSlider;
		private var normalCheckBox				:CheckBox;
		private var reflectivityCheckBox		:CheckBox;
		private var fresnelPowerSlider			:HSlider;
		private var fresnelSlider				:HSlider;
		private var gainSlider					:HSlider;
		private var rSlider					    :HSlider;
		private var gSlider					    :HSlider;
		private var bSlider					    :HSlider;
		private var rSlider2					:HSlider;
		private var gSlider2					:HSlider;
		private var bSlider2					:HSlider;
		
		private var alphaLabel					:Label;
		private var fresnelLabel				:Label;
		private var powerLabel					:Label;
		private var gainLabel					:Label;
		private var c1Label						:Label;
		private var c2Label						:Label;
		
		
		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this,m_resourceManager.windowX, m_resourceManager.windowY,"TwoColor Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			
			normalCheckBox   = new CheckBox(window, 5, 0, "Normal map",function(_e:Event):void{
				if(MaterialTwoColorFresnel(m_sceneObject.material).normalMap == null){
					MaterialTwoColorFresnel(m_sceneObject.material).normalMap = getMap("normalMap");
				}else{
					MaterialTwoColorFresnel(m_sceneObject.material).normalMap = null;
				}
			});
			reflectivityCheckBox = new CheckBox(window, 5, 10, "Reflectivity map",function(_e:Event):void{
				if(MaterialTwoColorFresnel(m_sceneObject.material).reflectivityMap == null){
					MaterialTwoColorFresnel(m_sceneObject.material).reflectivityMap = getMap("reflectionMap");
				}else{
					MaterialTwoColorFresnel(m_sceneObject.material).reflectivityMap = null;
				}
			});
			
			alphaLabel = new Label(window, 5, 25,"Opacity");
			alphaSlider = new HSlider(window, 5, 40, function(_e:Event):void{
				alphaLabel.text = "Opacity: "+ alphaSlider.value;
				MaterialTwoColorFresnel(m_sceneObject.material).opacity = alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			alphaLabel.text = "Opacity: "+ alphaSlider.value;
			
			fresnelLabel = new Label(window, 5, 50,"Fresnel Reflectance");
			fresnelSlider = new HSlider(window, 5, 65,function(_e:Event):void{
				MaterialTwoColorFresnel(m_sceneObject.material).fresnelReflectance = fresnelSlider.value;
				fresnelLabel.text = "Fresnel Reflectance: "+ fresnelSlider.value;
			});
			fresnelSlider.maximum = 1;
			fresnelSlider.minimum = 0;
			fresnelSlider.value = MaterialTwoColorFresnel(m_sceneObject.material).fresnelReflectance;	
			fresnelLabel.text = "Fresnel Reflectance: "+ fresnelSlider.value;
			
			powerLabel = new Label(window, 5, 75,"Fresnel Power");
			fresnelPowerSlider = new HSlider(window, 5, 90, function(_e:Event):void{
				MaterialTwoColorFresnel(m_sceneObject.material).fresnelPower = uint(fresnelPowerSlider.value);
				powerLabel.text = "Fresnel Power: "+ fresnelPowerSlider.value;
			});
			fresnelPowerSlider.maximum = 20;
			fresnelPowerSlider.minimum = 0;
			fresnelPowerSlider.value = MaterialTwoColorFresnel(m_sceneObject.material).fresnelPower;
			powerLabel.text = "Fresnel Power: "+ fresnelPowerSlider.value;
			
			gainLabel = new Label(window, 5, 100,"Gain");
			gainSlider = new HSlider(window, 5, 115, function(_e:Event):void{
				gainLabel.text = "Gain: "+ gainSlider.value;
				MaterialTwoColorFresnel(m_sceneObject.material).gain = gainSlider.value;
			});
			gainSlider.maximum = 1;
			gainSlider.minimum = 0;
			gainSlider.value = 0;
			gainLabel.text = "Gain: "+ gainSlider.value;
			
			c1Label = new Label(window, 5, 130,"Color 1");
			var colorChooser:ColorChooser = new ColorChooser( window, 5, 145, 0xFF0000, function(_e:Event):void{
				MaterialTwoColorFresnel(m_sceneObject.material).color1=  colorChooser.value;
			});
			colorChooser.usePopup = true;
			
			c2Label = new Label(window, 80, 130,"Color 2");
			var colorChooser2:ColorChooser = new ColorChooser( window, 80, 145, 0x0000FF, function(_e:Event):void{
				MaterialTwoColorFresnel(m_sceneObject.material).color2 =  colorChooser2.value;
			});
			colorChooser2.usePopup = true;

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