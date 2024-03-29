package
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.lights.RenderableLight;
	import com.yogurt3d.core.materials.MaterialBitmap;
	import com.yogurt3d.core.materials.MaterialTexture;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.test.BaseTest;
	import com.yogurt3d.test.CameraController;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import skybox.*;
	
	[SWF(width="638", height="478", frameRate="60")]
	public class wikiBitmap extends BaseTest
	{
		
		private var m_resourceManager	:ResourceManager;
		private var m_light				:RenderableLight;
		private var m_statsData			:BitmapData;
		private var m_loader			:LoadManager;
		
		private var m_sceneObject		:SceneObjectRenderable;
		
		public function wikiBitmap()
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
				scene.sceneColor = m_resourceManager.sceneColor;
				
				m_sceneObject 				= m_resourceManager.getObject();
				m_sceneObject.material 		= new MaterialTexture(getMap("colorMap"), true);
				
				
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
	
	}
}