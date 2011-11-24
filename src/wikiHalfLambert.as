package
{
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialHalfLambert;
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
	public class wikiHalfLambert extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiHalfLambert()
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
				if(m_resourceManager.includeUI)
					createUI();
				
				//scene.skyBox = new NightSkyBox;
				scene.sceneColor = m_resourceManager.sceneColor;
				
				m_sceneObject 				= m_resourceManager.getObject();
				
				m_sceneObject.material =  new MaterialHalfLambert(getMap("colorMap"));
				
				scene.addChild(m_resourceManager.getPlane());
				scene.addChild(m_sceneObject);
				scene.addChild(m_resourceManager.getStaticObj());
				scene.addChild(m_resourceManager.getAO());
				
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
		private var alphaSlider					:HSlider;
		
		private var aSlider						:HSlider;
		private var bSlider						:HSlider;
		private var gSlider						:HSlider;
		
		private var alphaLabel					:Label;
		private var aLabel						:Label;
		private var bLabel						:Label;
		private var gLabel						:Label;
		
		private var window2						:Window;
		
		private function createUI():void{
			
			new Y3DStyle();
			
			window = new Window(this, m_resourceManager.windowX, m_resourceManager.windowY,"HalfLambert Properties");
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
				MaterialHalfLambert(m_sceneObject.material).opacity = alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = 1;
			alphaLabel.text = "Opacity: "+ alphaSlider.value;
					
			aLabel = new Label(window, 5, 45,"Alpha");
			aSlider = new HSlider(window, 5, 60, function(_e:Event):void{
				MaterialHalfLambert(m_sceneObject.material).alpha = aSlider.value;
				aLabel.text = "Alpha: "+ aSlider.value;
			
			});
			aSlider.maximum = 1;
			aSlider.minimum = 0;
			aSlider.value = 0.5;
			
			bLabel = new Label(window, 5, 70,"Beta");
			bSlider = new HSlider(window, 5, 85, function(_e:Event):void{
				MaterialHalfLambert(m_sceneObject.material).beta = bSlider.value;
				bLabel.text = "Beta: "+ bSlider.value;
			});
			bSlider.maximum = 1;
			bSlider.minimum = 0;
			bSlider.value = 0.5;
			
			gLabel = new Label(window, 5, 95,"Gamma");
			gSlider = new HSlider(window, 5, 110, function(_e:Event):void{
				MaterialHalfLambert(m_sceneObject.material).gamma = gSlider.value;
				gLabel.text = "Gamma: "+ gSlider.value;
			});
			gSlider.maximum = 1;
			gSlider.minimum = 0;
			gSlider.value = 1;
			
			aLabel.text = "Alpha: "+ aSlider.value;
			bLabel.text = "Beta: "+ bSlider.value;
			gLabel.text = "Gamma: "+ gSlider.value;
			
			window2 = m_resourceManager.getLightUI(this.scene, this);
			window2.y = 209.5;
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