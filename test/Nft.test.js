const { assert } = require('chai')

const Nft = artifacts.require('./Nft')

require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('Nft', (accounts) => {
    let contract;
    before(async () => {
        contract = await Nft.deployed()
    })


    describe('deployment', async () => {
        it('contracts deployed successfully', async () => {

            const address = contract.address
            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        })
        it('has a name', async () => {
            const name = await contract.name()
            assert.equal(name, 'NFT smart cards')
        })
        it('has a symbol', async () => {
            const symbol = await contract.symbol()
            assert.equal(symbol, 'NFTz')
        })
    })
    describe('minting', async () => {
        it('creates a token', async () => {
            const result = await contract.mint('avi')
            const totalSupply = await contract.totalSupply()

            //success
            assert.equal(totalSupply, 1)
            const event = result.logs[0].args
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'from is the contract')
            assert.equal(event._to, accounts[0], 'to is msg sender')

            //failure
            await contract.mint('avi').should.be.rejected
        })
    })

    describe('indexing', async () => {
        it('lists nfts', async () => {
            await contract.mint('avi1')
            await contract.mint('avi2')
            await contract.mint('avi3')
            const totalSupply = await contract.totalSupply()

            let result = []
            let nft
            for (i = 1; i <= totalSupply; i++) {
                nft = await contract.nfts(i - 1)
                result.push(nft)
            }
            let expected = ['avi','avi1','avi2','avi3']
            assert.equal(result.join(','),expected.join(','))
        })

    })

})