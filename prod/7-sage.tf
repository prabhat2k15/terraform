module "sagemaker_example_studio" {
  source  = "Young-ook/sagemaker/aws//examples/studio"
  version = "0.0.8"
  # insert the 2 required variables here
  name = sage-app
  subnets = "sd-D23221"
}
