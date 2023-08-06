const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy Sprout
  const Sprout = await hre.ethers.getContractFactory("Sprout");
  const sprout = await Sprout.deploy(/* constructor arguments here */);
  await sprout.deployed();
  console.log("Sprout deployed to:", sprout.address);

  // Deploy S33DFactory
  const S33DFactory = await hre.ethers.getContractFactory("S33DFactory");
  const s33dFactory = await S33DFactory.deploy(/* constructor arguments here */);
  await s33dFactory.deployed();
  console.log("S33DFactory deployed to:", s33dFactory.address);

  // Deploy D1RT
  const D1RT = await hre.ethers.getContractFactory("D1RT");
  const d1rt = await D1RT.deploy(/* constructor arguments here */);
  await d1rt.deployed();
  console.log("D1RT deployed to:", d1rt.address);

  // Deploy S33D3xCH4NG3
  const S33D3xCH4NG3 = await hre.ethers.getContractFactory("S33D3xCH4NG3");
  const s33d3xch4ng3 = await S33D3xCH4NG3.deploy(/* constructor arguments here */);
  await s33d3xch4ng3.deployed();
  console.log("S33D3xCH4NG3 deployed to:", s33d3xch4ng3.address);

  // Deploy S33D3xCH4NG3Factory
  const S33D3xCH4NG3Factory = await hre.ethers.getContractFactory("S33D3xCH4NG3Factory");
  const s33d3xch4ng3Factory = await S33D3xCH4NG3Factory.deploy(/* constructor arguments here */);
  await s33d3xch4ng3Factory.deployed();
  console.log("S33D3xCH4NG3Factory deployed to:", s33d3xch4ng3Factory.address);

  // Deploy S33DSW4P
  const S33DSW4P = await hre.ethers.getContractFactory("S33DSW4P");
  const s33dsw4p = await S33DSW4P.deploy(/* constructor arguments here */);
  await s33dsw4p.deployed();
  console.log("S33DSW4P deployed to:", s33dsw4p.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
