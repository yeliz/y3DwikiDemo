package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialChromatic;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.test.BaseTest;
	import com.yogurt3d.test.CameraController;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import skybox.*;
	
	[SWF(width="638", height="478", frameRate="60")]
	public class wikiChromatic extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiChromatic()
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
				m_sceneObject.material = new MaterialChromatic(m_resourceManager.envMap, 
					null , null,
					new Vector3D(1.14, 1.12, 1.10 ),
					new Vector3D(0.15, 2.0, 0.0 ));
				
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
		private var glossCheck					:CheckBox;
		private var alphaSlider					:HSlider;
		private var ioRSlider					:HSlider;
		private var ioGSlider					:HSlider;
		private var ioBSlider					:HSlider;
		private var fresnelX					:HSlider;
		private var fresnelY					:HSlider;
		
		private var ioR							:Label;
		private var ioG							:Label;
		private var ioB							:Label;
		private var frRef						:Label;
		private var frPow						:Label;
		
		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this, m_resourceManager.windowX, m_resourceManager.windowY,"Chromatic Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			glossCheck = new CheckBox(window, 5, 5, "Gloss & Base Map",function(_e:Event):void{
				
				if(glossCheck.selected){
					MaterialChromatic(m_sceneObject.material).glossMap = getMap("glossMap");
					MaterialChromatic(m_sceneObject.material).texture  = getMap("colorMap");
				}	
				else{
					MaterialChromatic(m_sceneObject.material).glossMap = null;
					MaterialChromatic(m_sceneObject.material).texture  = null;
				}	
			});
			glossCheck.selected = false;
			
			new Label(window, 5, 20,"Opacity:");
			alphaSlider = new HSlider(window, 43, 25, function(_e:Event):void{
				MaterialChromatic(m_sceneObject.material).opacity = alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			
			new Label(window, 5, 40,"IO Channels(R,G,B)");
			ioRSlider = new HSlider(window, 20, 55, onIO);
			ioGSlider = new HSlider(window, 20, 70, onIO);	
			ioBSlider = new HSlider(window, 20, 85, onIO);
		
			ioRSlider.maximum = 3;
			ioRSlider.minimum = 0;
			ioRSlider.value = 1.14;
			
			ioGSlider.maximum = 3;
			ioGSlider.minimum = 0;
			ioGSlider.value = 1.12;
			
			ioBSlider.maximum = 3;
			ioBSlider.minimum = 0;
			ioBSlider.value = 1.10;
			
			ioR = new Label(window, 125, 50, "1.14");
			ioG = new Label(window, 125, 65, "1.12");
			ioB = new Label(window, 125, 80, "1.10");
			
			new Label(window, 5, 95,"Fresnel Reflectance:");
			fresnelX = new HSlider(window, 20, 110, onFresnel);
			
			new Label(window, 5, 120,"Fresnel Power:");
			fresnelY = new HSlider(window, 20, 135, onFresnel);
			
			fresnelX.maximum = 1;
			fresnelX.minimum = 0;
			fresnelX.value = 0.15;
			
			fresnelY.maximum = 7;
			fresnelY.minimum = 0;
			fresnelY.value = 2.0;	
			
			frRef = new Label(window, 125, 105, "0.15");
			frPow = new Label(window, 125, 130, "2.0");
		}
		
		private function onFresnel(_e:Event):void{
			MaterialChromatic(m_sceneObject.material).fresnel = new Vector3D(fresnelX.value, 
				fresnelY.value, 0.0, 0.0);
			
			frRef.text =  "" + fresnelX.value;
			frPow.text =  "" + fresnelY.value;
			
		}
		
		private function onIO(_e:Event):void{
			MaterialChromatic(m_sceneObject.material).Io = new Vector3D(ioRSlider.value,
				ioGSlider.value,ioBSlider.value);
			
			ioR.text = "" + ioRSlider.value;
			ioG.text = "" + ioGSlider.value;
			ioB.text = "" + ioBSlider.value;
			
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