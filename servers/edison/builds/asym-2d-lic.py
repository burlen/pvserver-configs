from paraview.simple import *
paraview.simple._DisableFirstRenderCameraReset()

# missm
# pvPrefix = '/work/ext/ParaView/sqtk-pv/PV/lib/'
# dataPrefix = '/work2/data/2d-asym/'

# gordon xede13
#pvPrefix = '/oasis/projects/nsf/gue998/bloring/installs/ParaView/4.0.0/lib/paraview-4.0/'
# gordon bench
#pvPrefix = '/oasis/projects/nsf/sds128/bloring/flat/builds/pv-build-mesa/lib'
#dataPrefix = '/oasis/projects/nsf/sds128/bloring/striped/2d-asym/'

# hopper
#pvPrefix = '/usr/common/graphics/ParaView/builds/PV3-next-mom-so/lib'
#dataPrefix = '/scratch/scratchdirs/loring/striped/asym2d/'

# edison
pvPrefix = '/usr/common/graphics/ParaView/builds/next/lib'
dataPrefix = '/scratch1/scratchdirs/loring/striped/asym2d/'

batch=1 # commnad line run
pvpy=1  # pvpython or pvbatch
rc=1

if batch:
  if pvpy:
    if rc:
      ReverseConnect('33345')
    else:
      Connect('localhost',11111)

  LICPlugin = '%s/libSurfaceLIC.so'%(pvPrefix)
  LoadPlugin(LICPlugin, False, globals())
  LoadPlugin(LICPlugin, True, globals())

  SQPlugin = '%s/libSciberQuestToolKit.so'%(pvPrefix)
  LoadPlugin(SQPlugin, False, globals())
  LoadPlugin(SQPlugin, True, globals())


inputData='%s/asym2d.bov'%(dataPrefix)
a2dasym_bov = SQBOVReader(FileName=inputData)
#a2dasym_bov.ISubset = [2000, 8000]
a2dasym_bov.ISubset = [0, 10239]
a2dasym_bov.JSubset = [0, 0]
a2dasym_bov.KSubset = [0, 2559]
a2dasym_bov.Arrays = ['ui']

AnimationScene2 = GetAnimationScene()
AnimationScene2.AnimationTime = 195000.0

view = GetRenderView()
view.AlphaBitPlanes=1
view.BackLightAzimuth=110.0
view.BackLightElevation=0.0
view.BackLightKBRatio=3.5
view.BackLightWarmth=0.5
view.Background=[0.31999694819562063, 0.3400015259021897, 0.4299992370489052]
view.Background2=[0.0, 0.0, 0.165]
view.BackgroundTexture=None
view.CacheKey=195000.0
view.CenterAxesVisibility=0
view.CenterOfRotation=[5119.5, 0.0, 1279.5]
view.CollectGeometryThreshold=100.0
view.CompressorConfig='vtkSquirtCompressor 0 3'
view.DepthPeeling=1
view.FillLightAzimuth=-10.0
view.FillLightElevation=-75.0
view.FillLightKFRatio=3.0
view.FillLightWarmth=0.4
view.HeadLightKHRatio=3.0
view.HeadLightWarmth=0.5
view.ImageReductionFactor=2
view.InteractionMode='2D'
view.KeyLightAzimuth=10.0
view.KeyLightElevation=50.0
view.KeyLightIntensity=0.75
view.KeyLightWarmth=0.6
view.LODResolution=0.5
view.LODThreshold=0.0
view.LightAmbientColor=[1.0, 1.0, 1.0]
view.LightDiffuseColor=[1.0, 1.0, 1.0]
view.LightIntensity=1.0
view.LightSpecularColor=[1.0, 1.0, 1.0]
view.LightSwitch=0
view.LightType='HeadLight'
view.MaintainLuminance=0
view.MaximumNumberOfPeels=4
view.MultiSamples=0
view.NonInteractiveRenderDelay=0.0
view.OrientationAxesInteractivity=0
view.OrientationAxesLabelColor=[1.0, 1.0, 1.0]
view.OrientationAxesOutlineColor=[1.0, 1.0, 1.0]
view.OrientationAxesVisibility=1
view.RemoteRenderThreshold=0.0
view.StencilCapable=1
view.StereoCapableWindow=1
view.StereoRender=0
view.StereoType='Red-Blue'
view.StillRenderImageReductionFactor=1
view.UseCache=0
view.UseGradientBackground=0
view.UseInteractiveRenderingForSceenshots=0
view.UseLight=1
view.UseOffscreenRendering=0
view.UseOffscreenRenderingForScreenshots=0
view.UseOutlineForLODRendering=1
view.UseTexturedBackground=0
view.ViewPosition=[0, 0]
view.ViewSize=[1600, 400]
view.ViewTime=195000.0
view.CameraClippingRange=[20184.755659911323, 20694.47171192929]
view.CameraFocalPoint=[5119.5, 0.0, 1279.5]
view.CameraParallelProjection=0
view.CameraParallelScale=1339.941524088929
view.CameraPosition=[5119.5, -20388.64208071851, 1279.5]
view.CameraViewAngle=30.0
view.CameraViewUp=[0.0, 0.0, 1.0]
view.EyeAngle=2.0

# whote to black
#lut = GetLookupTableForArray("ui",
#    3, RGBPoints=[2.4187229649061175e-05, 0.0,0.0,0.0, 0.07131052582366978, 1.0,1.0,1.0],
#    VectorMode='Magnitude', NanColor=[0.25, 0.0, 0.0], ColorSpace='Diverging',
#    ScalarRangeInitialized=1.0, AllowDuplicateScalars=1)

# blue to red
lut = GetLookupTableForArray("ui",
    3, RGBPoints=[2.4187229649061175e-05, 0.23, 0.299, 0.754, 0.07131052582366978, 0.706, 0.016, 0.15],
    VectorMode='Magnitude', NanColor=[0.25, 0.0, 0.0], ColorSpace='Diverging',
    ScalarRangeInitialized=1.0, AllowDuplicateScalars=1)

## black-body
#lut = GetLookupTableForArray("ui", 3, NanColor=[0.0, 0.4980392156862745, 1.0],
#    RGBPoints=[1.5332076371795493e-05, 0.0, 0.0, 0.0, 0.03427913218508128, 0.9019607843137255, 0.0, 0.0, 0.06854293229379076, 0.9019607843137255, 0.9019607843137255, 0.0, 0.08567483234814549, 1.0, 1.0, 1.0],
#    ColorSpace='RGB')

#lut = GetLookupTableForArray("ui",
#    3, NanColor=[0.0, 0.4980392156862745, 1.0],
#    RGBPoints=[1.5332076371795493e-05, 0.0, 0.0, 0.0,
#        0.03427913218508128, 0.9019607843137255, 0.0, 0.0,
#        0.06854293229379076, 0.9019607843137255, 0.9019607843137255, 0.0,
#        0.08567483234814549, 1.0, 1.0, 1.0])

rep = Show()
#rep.Representation = 'Outline'
#Render()
#rep.ColorArrayName = ('POINT_DATA', 'ui')
#rep.LookupTable = lut
#rep.ScaleFactor = 1023.9000000000001
#rep.SelectionPointFieldDataArrayName = 'ui'

##DataRepresentation1.Representation = 'Surface'
#DataRepresentation1.ScalarOpacityUnitDistance = 35.53354894777224
#DataRepresentation1.SelectInputVectors = ['POINTS', 'ui']
#DataRepresentation1.NoiseTextureSize = 256
#DataRepresentation1.EnhanceContrast = 'LIC Only'
#DataRepresentation1.NumberOfSteps = 4000
#DataRepresentation1.ColorMode = 'Multiply'
#DataRepresentation1.GenerateNoiseTexture = 1
#DataRepresentation1.LowLICContrastEnhancementFactor = 0.115
#DataRepresentation1.StepSize = 15.0
#DataRepresentation1.NoiseGrainSize = 4
#DataRepresentation1.NormalizeVectors = 0
#DataRepresentation1.NoiseType = 'Perlin'
#DataRepresentation1.Representation = 'Surface LIC'
#Render()

rep.CubeAxesVisibility=0
rep.Representation='Surface LIC'
rep.SelectionCellFieldDataArrayName='vtkOriginalCellIds'
rep.SelectionPointFieldDataArrayName='ui'
rep.SelectionVisibility=1
rep.Visibility=1
rep.AllowSpecularHighlightingWithScalarColoring=0
rep.Ambient=0.0
rep.AmbientColor=[1.0, 1.0, 1.0]
rep.AntiAlias=0
rep.AxesOrigin=[0.0, 0.0, 0.0]
rep.BackfaceAmbientColor=[1.0, 1.0, 1.0]
rep.BackfaceDiffuseColor=[1.0, 1.0, 1.0]
rep.BackfaceOpacity=1.0
rep.BackfaceRepresentation='Follow Frontface'
rep.BlockColor={}
rep.BlockOpacity={}
rep.BlockVisibility=[]
rep.ColorArrayName=('POINT_DATA', 'ui')
rep.ColorAttributeType='POINT_DATA'
rep.CubeAxesColor=[1.0, 1.0, 1.0]
rep.CubeAxesCornerOffset=0.0
rep.CubeAxesFlyMode='Closest Triad'
rep.CubeAxesGridLineLocation='All Faces'
rep.CubeAxesInertia=1
rep.CubeAxesTickLocation='Inside'
rep.CubeAxesUseDefaultXTitle=1
rep.CubeAxesUseDefaultYTitle=1
rep.CubeAxesUseDefaultZTitle=1
rep.CubeAxesXAxisMinorTickVisibility=1
rep.CubeAxesXAxisTickVisibility=1
rep.CubeAxesXAxisVisibility=1
rep.CubeAxesXGridLines=0
rep.CubeAxesXLabelFormat='%-#6.3g'
rep.CubeAxesXTitle='X-Axis'
rep.CubeAxesYAxisMinorTickVisibility=1
rep.CubeAxesYAxisTickVisibility=1
rep.CubeAxesYAxisVisibility=1
rep.CubeAxesYGridLines=0
rep.CubeAxesYLabelFormat='%-#6.3g'
rep.CubeAxesYTitle='Y-Axis'
rep.CubeAxesZAxisMinorTickVisibility=1
rep.CubeAxesZAxisTickVisibility=1
rep.CubeAxesZAxisVisibility=1
rep.CubeAxesZGridLines=0
rep.CubeAxesZLabelFormat='%-#6.3g'
rep.CubeAxesZTitle='Z-Axis'
rep.CustomBounds=[0.0, 1.0, 0.0, 1.0, 0.0, 1.0]
rep.CustomBoundsActive=[0, 0, 0]
rep.CustomRange=[0.0, 1.0, 0.0, 1.0, 0.0, 1.0]
rep.CustomRangeActive=[0, 0, 0]
rep.Diffuse=1.0
rep.DiffuseColor=[1.0, 1.0, 1.0]
rep.EdgeColor=[0.0, 0.0, 0.5000076295109483]
rep.InterpolateScalarsBeforeMapping=1
rep.Interpolation='Gouraud'
rep.InterpolationType='Cubic'
rep.LICIntensity=0.8
rep.LineWidth=1.0
rep.LookupTable=lut
rep.MapScalars=1
rep.Masking=0
rep.MaxNoiseValue=0.8
rep.MeshVisibility=0
rep.MinNoiseValue=0.0
rep.NonlinearSubdivisionLevel=1
rep.Opacity=1.0
rep.Orient=0
rep.Orientation=[0.0, 0.0, 0.0]
rep.OrientationMode='Direction'
rep.Origin=[0.0, 0.0, 0.0]
rep.OriginalBoundsRangeActive=[0, 0, 0]
rep.Pickable=1
rep.PointSize=2.0
rep.Position=[0.0, 0.0, 0.0]
#rep.ScalarOpacityFunction=lut.ScalarOpacityFunction
rep.ScalarOpacityUnitDistance=24.277541059313837
rep.Scale=[1.0, 1.0, 1.0]
rep.ScaleFactor=511.90000000000003
rep.ScaleMode='No Data Scaling Off'
rep.Scaling=0
rep.SelectMaskArray=''
rep.SelectOrientationVectors=''
rep.SelectScaleArray=''
rep.SelectionCellLabelBold=0
rep.SelectionCellLabelColor=[0.0, 1.0, 0.0]
rep.SelectionCellLabelFontFamily='Arial'
rep.SelectionCellLabelFontSize=18
rep.SelectionCellLabelFormat=''
rep.SelectionCellLabelItalic=0
rep.SelectionCellLabelJustification='Left'
rep.SelectionCellLabelOpacity=1.0
rep.SelectionCellLabelShadow=0
rep.SelectionCellLabelVisibility=0
rep.SelectionColor=[1.0, 0.0, 1.0]
rep.SelectionLineWidth=2.0
rep.SelectionOpacity=1.0
rep.SelectionPointLabelBold=0
rep.SelectionPointLabelColor=[0.5, 0.5, 0.5]
rep.SelectionPointLabelFontFamily='Arial'
rep.SelectionPointLabelFontSize=18
rep.SelectionPointLabelFormat=''
rep.SelectionPointLabelItalic=0
rep.SelectionPointLabelJustification='Left'
rep.SelectionPointLabelOpacity=1.0
rep.SelectionPointLabelShadow=0
rep.SelectionPointLabelVisibility=0
rep.SelectionPointSize=5.0
rep.SelectionRepresentation='Wireframe'
rep.SelectionUseOutline=0
rep.Shade=0
rep.Slice=0
rep.SliceMode='XY Plane'
#rep.Source=None
rep.Specular=0.1
rep.SpecularColor=[1.0, 1.0, 1.0]
rep.SpecularPower=100.0
rep.StaticMode=0
rep.StepSize=10.0
rep.SuppressLOD=0
rep.Texture=None
rep.UseAxesOrigin=0
rep.UserTransform=[1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0]
rep.VolumeRenderingMode='Smart'
# surface lic
rep.SelectInputVectors=['POINTS', 'ui']
rep.NumberOfSteps=5000
rep.NormalizeVectors=0
rep.ColorMode='Multiply'
rep.CompositeStrategy='INPLACE'
rep.EnhancedLIC=1
rep.EnhanceContrast='LIC and Color'
rep.HighColorContrastEnhancementFactor=0.0
rep.HighLICContrastEnhancementFactor=0.0
rep.ImpulseNoiseBackgroundValue=0.0
rep.ImpulseNoiseProbability=0.5
rep.LowColorContrastEnhancementFactor=0.0
rep.LowLICContrastEnhancementFactor=0.1
rep.MapModeBias=0.0
rep.MaskColor=[0.5, 0.5, 0.5]
rep.MaskIntensity=0.0
rep.MaskOnSurface=1
rep.MaskThreshold=0.0
rep.GenerateNoiseTexture=1
rep.NoiseGeneratorSeed=1
rep.NoiseGrainSize=4
rep.NoiseTextureSize=128
rep.NoiseType='Perlin'
rep.NumberOfNoiseLevels=1024
rep.UseLICForLOD=0
#
Render()


outputImage='asym-2d-200.png'
WriteImage(outputImage)

rep.WriteLog = 'SurfaceLIC.log'
