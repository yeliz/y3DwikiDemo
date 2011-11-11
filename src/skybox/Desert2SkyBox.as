package skybox
{
	import com.yogurt3d.core.sceneobjects.SkyBox;
	import com.yogurt3d.core.texture.CubeTextureMap;
	
	import flash.display.BitmapData;
	
	public class Desert2SkyBox extends SkyBox
	{
		[Embed(source="../resources/skybox/new/sb1_left.jpg")]
		private var embednegativeX:Class;
		
		[Embed(source="../resources/skybox/new/sb1_right.jpg")]
		private var embedpositiveX:Class;
		
		[Embed(source="../resources/skybox/new/sb1_bottom.jpg")]
		private var embednegativeY:Class;
		
		[Embed(source="../resources/skybox/new/sb1_top.jpg")]
		private var embedpositiveY:Class;
		
		[Embed(source="../resources/skybox/new/sb1_front.jpg")]
		private var embedpositiveZ:Class;
		
		[Embed(source="../resources/skybox/new/sb1_back.jpg")]
		private var embednegativeZ:Class;
		
		
		public function Desert2SkyBox()
		{
			var cubeTexture:CubeTextureMap = new CubeTextureMap();
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_X, new embednegativeX() );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Y, new embednegativeY() );
			cubeTexture.setFace( CubeTextureMap.NEGATIVE_Z, new embednegativeZ() );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_X, new embedpositiveX() );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Y, new embedpositiveY() );
			cubeTexture.setFace( CubeTextureMap.POSITIVE_Z, new embedpositiveZ() );
			super(cubeTexture,	10 );
			
		}
	}
}