let Flashloan = artifacts.require("Flashloan")

module.exports = async function (deployer) {
    try {
        await deployer.deploy(Flashloan)
    } catch (e) {
        console.log(`Error in migration: ${e.message}`)
    }
}