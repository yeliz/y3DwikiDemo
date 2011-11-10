package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialDiffuseTexture;
	import com.yogurt3d.core.materials.base.Color;
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
	public class wikiDiffuseTexture extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiDiffuseTexture()
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
				
				m_sceneObject.material =  new MaterialDiffuseTexture(getMap("colorMap"));
				(m_sceneObject.material as MaterialDiffuseTexture).normalMap =  getMap("normalMap");
				
				m_sceneObject.material.diffuseColor.setColorUint(0xFFA3FF);
				m_sceneObject.material.diffuseColor.a = 1.0;
				
				m_sceneObject.material.ambientColor.setColorUint(0xF55E00);
				m_sceneObject.material.ambientColor.a = 1.0;
				
			
				
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
		private var alphaLabel					:Label;
		private var normalCheckBox				:CheckBox;
		
		private var window2						:Window;
		private var window3						:Window;
		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this,  m_resourceManager.windowX, m_resourceManager.windowY,"DiffuseFill Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			alphaLabel = new Label(window, 5, 5,"Opacity");
			alphaSlider = new HSlider(window, 5, 30, function(_e:Event):void{
				alphaLabel.text = "Opacity: "+ alphaSlider.value;
				MaterialDiffuseTexture(m_sceneObject.material).opacity = alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			alphaLabel.text = "Opacity: "+ alphaSlider.value;
			
			normalCheckBox   = new CheckBox(window, 5, 45, "Normal map",function(_e:Event):void{
				if(MaterialDiffuseTexture(m_sceneObject.material).normalMap == null){
					MaterialDiffuseTexture(m_sceneObject.material).normalMap = getMap("normalMap");
				}else{
					MaterialDiffuseTexture(m_sceneObject.material).normalMap = null;
				}
			});
			normalCheckBox.selected = true;
			
			window3 = m_resourceManager.getMaterialDiffuseUI(this.scene, this, m_sceneObject.material);
			window3.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window3.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window3.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
//			m_sceneObject.material.ambientColor.setColorUint(0xFFFF61);
//			m_sceneObject.material.ambientColor.a = 0.48;
			
			window2 = m_resourceManager.getLightUI(this.scene, this);
			window2.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window2.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window2.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);	
			
//			m_sceneObject.material.diffuseColor.setColorUint(0xFFFFB3);
//			m_sceneObject.material.diffuseColor.a = 0.92;
		
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