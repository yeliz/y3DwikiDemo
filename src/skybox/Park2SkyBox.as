package skybox
{
	import com.yogurt3d.core.sceneobjects.SkyBox;
	import com.yogurt3d.core.texture.CubeTextureMap;
	
	import flash.display.BitmapData;
	
	public class Park2SkyBox extends SkyBox
	{
		[Embed(source='../resources/skybox/Park2/posx.jpg')]
		private var embedpositiveX:Class;
		
		[Embed(source='../resources/skybox/Park2/negx.jpg')]
		private var embednegativeX:Class;
		
		[Embed(source='../resources/skybox/Park2/posy.jpg')]
		private var embedpositiveY:Class;
		
		[Embed(source='../resources/skybox/Park2/negy.jpg')]
		private var embednegativeY:Class;
		
		[Embed(source='../resources/skybox/Park2/posz.jpg')]
		private var embedpositiveZ:Class;
		
		[Embed(source='../resources/skybox/Park2/negz.jpg')]
		private var embednegativeZ:Class;
		
		
		public function Park2SkyBox(size:Number = 10.0)
		{
			var cubeTexture:CubeTextureMap = new CubeTextureMap();
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_X, new embednegativeX() );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Y, new embednegativeY() );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Z, new embednegativeZ() );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_X, new embedpositiveX() );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Y, new embedpositiveY() );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Z, new embedpositiveZ() );
			super(cubeTexture,	size );
			
		}
	}
}