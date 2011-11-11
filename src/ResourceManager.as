package
{
	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Slider;
	import com.bit101.components.Window;
	import com.yogurt3d.core.cameras.Camera;
	import com.yogurt3d.core.geoms.Mesh;
	import com.yogurt3d.core.lights.ELightType;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialDiffuseFill;
	import com.yogurt3d.core.materials.MaterialDiffuseTexture;
	import com.yogurt3d.core.materials.MaterialTexture;
	import com.yogurt3d.core.materials.base.Color;
	import com.yogurt3d.core.materials.base.Material;
	import com.yogurt3d.core.sceneobjects.Scene;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.texture.CubeTextureMap;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.io.loaders.DataLoader;
	import com.yogurt3d.io.loaders.DisplayObjectLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.parsers.TextureMap_Parser;
	import com.yogurt3d.io.parsers.Y3D_Parser;
	import com.yogurt3d.test.BaseTest;
	import com.yogurt3d.test.TargetCamera;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.Dictionary;
	
	import skybox.Desert2SkyBox;
	import skybox.LakeSkyBox;
	import skybox.NightSkyBox;
	import skybox.Park2SkyBox;

	public class ResourceManager
	{
		private var m_loader					:LoadManager;
		private var m_imageDict					:Dictionary;
		private var m_materialDict				:Dictionary;
		
		private var m_obj						:String;
		private var m_staticPath				:String;
		private var m_planePath					:String;
		private var m_aopath					:String;
		private var m_envMap					:CubeTextureMap;
		private var m_static					:SceneObjectRenderable;
		private var m_plane						:SceneObjectRenderable;
		private var m_sceneObject				:SceneObjectRenderable;
		private var m_aoObject					:SceneObjectRenderable;
		private var m_light						:RenderableLight;
		private var m_sceneColor				:Color;
		public var windowX						:Number = 0;
		public var windowY						:Number = 0;
		public var moveRatio					:Number = 0;
		public var width						:Number = 160;
		public var height						:Number = 210;
		public var includeUI					:Boolean = true;
		
		public function ResourceManager()
		{
			m_imageDict = new Dictionary();
			m_imageDict["colorMap"] 		= "../resources/models/Images/mat_color_1.png";
			m_imageDict["glossMap"] 		= "../resources/models/Images/gloss_map_01.jpg";
			m_imageDict["reflectionMap"] 	= "../resources/models/Images/mat_reflect_1.png";
			m_imageDict["normalMap"] 		= "../resources/models/Images/mat_normal_1.jpg";
			m_imageDict["specularMap"] 		= "../resources/models/Images/mat_spec_grayscale.png";
			m_imageDict["colorMap2"] 		= "../resources/models/Images/mat_color_3.png";
			
			m_imageDict["colorMapStatic"] 	= "../resources/models/Images/stat_color.jpg";
			m_imageDict["plane"] 	= "../resources/skybox/new/yeliz.jpg";
			m_imageDict["aoPlane"] 	= "../resources/skybox/new/ao_plane.png";
			
			m_obj = "../resources/models/mat.y3d";
			m_staticPath = "../resources/models/stat.y3d";
			m_planePath = "../resources/skybox/new/grid_meshnew.y3d";
			
			m_aopath = "../resources/skybox/new/ao_plane.y3d";
			
			m_envMap = new Desert2SkyBox().texture;
			m_sceneColor = new Color(1,1,1,1);
			
		}
		
		public function get sceneColor():Color
		{
			return m_sceneColor;
		}

		public function set sceneColor(value:Color):void
		{
			m_sceneColor = value;
		}

		public function createLight():RenderableLight{
		
			m_light = new RenderableLight(ELightType.DIRECTIONAL, 0xD2CFB9, 5);
			m_light.transformation.position = new Vector3D(0,100,300);
			m_light.transformation.rotationY = -180;
			m_light.transformation.rotationZ = -90;
			m_light.intensity = 0.75;
		
			return m_light;
		}
		
		public function get envMap():CubeTextureMap{
			return m_envMap;
		}
		
		public function get loader():LoadManager
		{
			return m_loader;
		}

		public function set loader(value:LoadManager):void
		{
			m_loader = value;
		}

		public function getMap(_key:String):TextureMap{
			
			return m_loader.getLoadedContent(m_imageDict[_key]);
		}
		
		public function getObject():SceneObjectRenderable{
			m_sceneObject = new SceneObjectRenderable();
			m_sceneObject.geometry 	= m_loader.getLoadedContent(m_obj)	
			m_sceneObject.transformation.y = -0.3;
			if(!includeUI)
				m_sceneObject.transformation.x = 0.2;
			return m_sceneObject;
		}
		
		public function getStaticObj():SceneObjectRenderable{
			m_static = new SceneObjectRenderable();
			m_static.geometry 	= m_loader.getLoadedContent(m_staticPath);
			m_static.material = new MaterialDiffuseTexture(getMap("colorMapStatic"));
			m_static.material.ambientColor.a = 0.2;
			m_static.transformation.y = -0.3;
			m_static.renderLayer = 101;
			if(!includeUI)
				m_static.transformation.x = 0.2;
			//m_static.transformation.x = 0.5;
			return m_static;
		}
		public function getPlane():SceneObjectRenderable{
			m_plane = new SceneObjectRenderable();
			m_plane.geometry 	= m_loader.getLoadedContent(m_planePath);
			m_plane.material = new MaterialTexture(getMap("plane"));
		//	m_plane.material.ambientColor.a = 0.2;
			m_plane.transformation.scale = 2.0;
			m_plane.transformation.y = -0.3;
			m_plane.transformation.z = -1.9;
			return m_plane;
		}
		public function getAO():SceneObjectRenderable{
			m_aoObject = new SceneObjectRenderable();
			m_aoObject.geometry 	= m_loader.getLoadedContent(m_aopath);
			m_aoObject.material = new MaterialTexture(getMap("aoPlane"));
			m_aoObject.material.opacity = 0.4;
			//(m_aoObject.material as MaterialTexture).alphaTexture = true;
		//	(m_aoObject.material as MaterialTexture).doubleSided = true;
		//	(m_aoObject.material as MaterialTexture).
			m_aoObject.transformation.y = -0.3;
			if(!includeUI)
				m_aoObject.transformation.x = 0.2;
		
			return m_aoObject;
		}
		
		
		public function getMaterialSpecularUI(scene:Scene, parent:BaseTest, material:Material):Window{
			
			var window2:Window = new Window(parent, 0,209.5,"Material Properties");
			window2.width = 160;
			window2.height = 150;
			window2.mouseEnabled = true;
			window2.hasMinimizeButton = true;
			
			var slider:Slider;
			var slider2:Slider;
			var slider3:Slider;
			
			var label2:Label = new Label(window2,5, 0,"AmbientColor");
			var colorChooser2:ColorChooser = new ColorChooser( window2, 80, 0, material.ambientColor.toUintRGB(), function():void{
				material.ambientColor.setColorUint( (slider.value * 255) << 24 | colorChooser2.value );
				
			});
			colorChooser2.usePopup = true;
			
			var label3:Label = new Label(window2,5,15,"AmbientIntensity:"+material.ambientColor.a);
			slider = new Slider( "horizontal", window2, 5, 30, function():void{
				material.ambientColor.a = slider.value;
				label3.text = "AmbientIntensity:"+slider.value;
			});
			slider.value = material.ambientColor.a;
			slider.minimum = 0;
			slider.maximum = 1;
			
			var label4:Label = new Label(window2,5,45,"DiffuseColor");
			var colorChooser3:ColorChooser = new ColorChooser( window2, 80, 45, material.diffuseColor.toUintRGB(), function():void{
				material.diffuseColor.setColorUint( (slider2.value * 255) << 24 | colorChooser3.value );
			});
			colorChooser3.usePopup = true;
			
			var label5:Label = new Label(window2,5,60,"DiffuseIntensity:"+ material.diffuseColor.a);
			var slider2:Slider = new Slider( "horizontal", window2, 5, 75, function():void{
				material.diffuseColor.a = slider2.value;
				label5.text = "DiffuseIntensity:" + slider2.value;
			});
			slider2.value = material.diffuseColor.a;
			slider2.minimum = 0;
			slider2.maximum = 1;
			
			var label7:Label = new Label(window2,5,90,"SpecularColor");
			var colorChooser4:ColorChooser = new ColorChooser( window2, 80, 90, material.specularColor.toUintRGB(), function():void{
				material.diffuseColor.setColorUint( (slider3.value * 255) << 24 | colorChooser3.value );
			});
			colorChooser4.usePopup = true;
			
			var label6:Label = new Label(window2,5,105,"SpecularIntensity:"+ material.specularColor.a);
			var slider3:Slider = new Slider( "horizontal", window2, 5, 120, function():void{
				material.specularColor.a = slider3.value;
				label6.text = "SpecularIntensity:" + slider3.value;
			});
			slider3.value = material.specularColor.a;
			slider3.minimum = 0;
			slider3.maximum = 1;
			
			return window2;
		}
		
		public function getMaterialDiffuseUI(scene:Scene, parent:BaseTest, material:Material):Window{
			
			var window2:Window = new Window(parent, 0,209.5,"Material Properties");
			window2.width = 160;
			window2.height = 150;
			window2.mouseEnabled = true;
			window2.hasMinimizeButton = true;
			
			var slider:Slider;
			var slider2:Slider;
			
			var label2:Label = new Label(window2,5, 0,"AmbientColor");
			var colorChooser2:ColorChooser = new ColorChooser( window2, 5, 15, material.ambientColor.toUintRGB(), function():void{
				material.ambientColor.setColorUint( (slider.value * 255) << 24 | colorChooser2.value );
		
				
			});
			colorChooser2.usePopup = true;
			
			var label3:Label = new Label(window2,5,30,"AmbientIntensity:"+material.ambientColor.a);
			slider = new Slider( "horizontal", window2, 5, 45, function():void{
				material.ambientColor.a = slider.value;
				label3.text = "AmbientIntensity:"+slider.value;
			});
			slider.value = material.ambientColor.a;
			slider.minimum = 0;
			slider.maximum = 1;
			
		
			var label4:Label = new Label(window2,5,60,"DiffuseColor");
			var colorChooser3:ColorChooser = new ColorChooser( window2, 5, 75, material.diffuseColor.toUintRGB(), function():void{
				material.diffuseColor.setColorUint( (slider2.value * 255) << 24 | colorChooser3.value );
			});
			colorChooser3.usePopup = true;
			
			var label5:Label = new Label(window2,5,90,"DiffuseIntensity:"+ material.diffuseColor.a);
			var slider2:Slider = new Slider( "horizontal", window2, 5, 105, function():void{
				material.diffuseColor.a = slider2.value;
				label5.text = "DiffuseIntensity:" + slider2.value;
			});
			slider2.value = material.diffuseColor.a;
			slider2.minimum = 0;
			slider2.maximum = 1;
		
			return window2;
		}
		
		public function getLightUI(scene:Scene, parent:BaseTest):Window{
			
			var window2:Window = new Window(parent, 0, 360,"Light Properties");
			window2.width = 160;
			window2.height = 120;
			window2.mouseEnabled = true;
			window2.hasMinimizeButton = true;
			
		
			var cCombo:ComboBox = new ComboBox(window2, 5, 0, "spot");
			cCombo.selectedIndex = 0;
			
			cCombo.addItem("spot");
			cCombo.addItem("point");
			cCombo.addItem("directional");
			
			
			new Label(window2, 5, 15,"Rot X");
			var xSlider:HSlider = new HSlider(window2, 5, 30, function( _e:Event ):void{
				m_light.transformation.rotationX = xSlider.value;
			});
			xSlider.maximum = 360;
			xSlider.minimum = -360;
			xSlider.value = 0;
			
			new Label(window2, 5, 40,"Rot Y");
			var ySlider:HSlider = new HSlider(window2, 5, 55, function( _e:Event ):void{
				m_light.transformation.rotationY = ySlider.value;
			});
			ySlider.maximum = 360;
			ySlider.minimum = -360;
			ySlider.value = -180;
			
			new Label(window2, 5, 65,"Rot Z");
			var zSlider:HSlider = new HSlider(window2, 5, 80, function( _e:Event ):void{
				m_light.transformation.rotationZ = zSlider.value;
			});
			zSlider.maximum = 360;
			zSlider.minimum = -360;
			zSlider.value = 0;
			
			cCombo.addEventListener(Event.SELECT, function( _e:Event ):void{
				scene.removeChild(m_light);
				
				if(cCombo.selectedItem == 0)
					m_light = new RenderableLight(ELightType.SPOT, 0xD2CFB9, 5);
				else if (cCombo.selectedItem == 1)
					m_light = new RenderableLight(ELightType.POINT, 0xD2CFB9, 5);
				else{
					m_light = new RenderableLight(ELightType.DIRECTIONAL, 0xD2CFB9, 5);
				} 
				m_light.transformation.position = new Vector3D(0,100,300);
				m_light.intensity = 0.75;
				
				m_light.transformation.rotationX = xSlider.value;
				m_light.transformation.rotationY = ySlider.value;
				m_light.transformation.rotationZ = zSlider.value;
				
				scene.addChild( m_light );
				
			});
		
			return window2;
		}
		
		public function setDefaultCamera(_camera:Camera):void{
		
			// set camera projection
			_camera.frustum.setProjectionPerspective( 35, 800/600, 1, 7000);
			
			//CameraController.moveRatio = 1;
			// setup default camera pos
			TargetCamera(_camera).dist 				= 3.0;
			TargetCamera(_camera).rotY 				= 210;
			TargetCamera(_camera).rotX 				= -30;
			TargetCamera(_camera).limitEnabled 		= true;
			TargetCamera(_camera).limitRotXMin 		= -30;
			TargetCamera(_camera).limitRotXMax 		= -30;
		}
		
		
		public function loadResources():void{
		
			m_loader = new LoadManager();
			
			for (var key:Object in m_imageDict) {
				m_loader.add( m_imageDict[key], DisplayObjectLoader, TextureMap_Parser );
			}
			
			m_loader.add(m_obj, DataLoader, Y3D_Parser, {dataFormat: URLLoaderDataFormat.BINARY}  );
			m_loader.add(m_staticPath, DataLoader, Y3D_Parser, {dataFormat: URLLoaderDataFormat.BINARY}  );
			m_loader.add(m_planePath, DataLoader, Y3D_Parser, {dataFormat: URLLoaderDataFormat.BINARY}  );
			m_loader.add(m_aopath, DataLoader, Y3D_Parser, {dataFormat: URLLoaderDataFormat.BINARY}  );
			
		}
	}
}