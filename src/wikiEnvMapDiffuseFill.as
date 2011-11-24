package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialEnvMapDiffuseFill;
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
	public class wikiEnvMapDiffuseFill extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiEnvMapDiffuseFill()
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
				
				m_sceneObject.material = new MaterialEnvMapDiffuseFill(m_resourceManager.envMap, 0x97AF22, null, null, 0.3);
				m_sceneObject.material.ambientColor.a = 0.5;
				
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
		private var window2						:Window;
		private var window3						:Window;
		private var normalCheckBox				:CheckBox;
		private var reflectivityCheckBox		:CheckBox;
		private var alphaSlider					:HSlider;
		
		private function createUI():void{
			
			//Style.setStyle( new Y3DStyle());
			new Y3DStyle();
			
			window = new Window(this,  m_resourceManager.windowX, m_resourceManager.windowY,"EnvMappingDiffuseFill Properties");
			window.width = m_resourceManager.width;
			window.height = m_resourceManager.height;
			window.mouseEnabled = true;
			window.hasMinimizeButton = true;
			
			window.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			normalCheckBox = new CheckBox(window, 5, 5, "Normal Map",function(_e:Event):void{
				if(MaterialEnvMapDiffuseFill(m_sceneObject.material).normalMap == null){
					MaterialEnvMapDiffuseFill(m_sceneObject.material).normalMap = getMap("normalMap");
				}else{
					MaterialEnvMapDiffuseFill(m_sceneObject.material).normalMap = null;
				}
			});
			normalCheckBox.selected = false;
			
			reflectivityCheckBox = new CheckBox(window, 5, 20, "Reflectivity map",function(_e:Event):void{
				if(MaterialEnvMapDiffuseFill(m_sceneObject.material).reflectivityMap == null)
					MaterialEnvMapDiffuseFill(m_sceneObject.material).reflectivityMap = getMap("reflectionMap");
				else
					MaterialEnvMapDiffuseFill(m_sceneObject.material).reflectivityMap = null;
			});
			
			var alphaLabel:Label = new Label(window, 5, 35,"Opacity: 1");
			alphaSlider = new HSlider(window, 5, 50, function(_e:Event):void{
				alphaLabel.text = "Opacity: "+ alphaSlider.value;
				MaterialEnvMapDiffuseFill(m_sceneObject.material).opacity = alphaSlider.value;
			});
			alphaSlider.maximum = 1;
			alphaSlider.minimum = 0;
			alphaSlider.value = MaterialEnvMapDiffuseFill(m_sceneObject.material).opacity;
			
			var alphaL:Label = new Label(window, 5, 70,"Alpha: "+MaterialEnvMapDiffuseFill(m_sceneObject.material).alpha);
			var alphaS:HSlider = new HSlider(window, 5, 85, function(_e:Event):void{
				alphaL.text = "Alpha: "+ alphaS.value;
				MaterialEnvMapDiffuseFill(m_sceneObject.material).alpha = alphaS.value;
			});
			alphaS.maximum = 1;
			alphaS.minimum = 0;
			alphaS.value = MaterialEnvMapDiffuseFill(m_sceneObject.material).alpha;
			
			new Label(window, 5, 100,"Color");
			var colorChooser:ColorChooser = new ColorChooser( window, 5, 115, 0x97AF22, function(_e:Event):void{
				MaterialEnvMapDiffuseFill(m_sceneObject.material).color =  colorChooser.value;
			});
			colorChooser.usePopup = true;
			
			window2 = m_resourceManager.getMaterialDiffuseUI(this.scene, this, m_sceneObject.material);
			window2.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window2.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window2.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);	
			
			
			window3 = m_resourceManager.getLightUI(this.scene, this);
			window3.addEventListener(MouseEvent.CLICK, onWindowSelect);
			window3.addEventListener(MouseEvent.DOUBLE_CLICK, onWindowSelect);
			window3.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);	
			
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