import React, { Component } from 'react'
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import Nft from '../abis/Nft.json'

export default class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      account: '',
      contract: null,
      totalSupply: 0,
      nfts: [],
    }
  }

  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData()
  }

  async loadWeb3() {
    const provider = await detectEthereumProvider();
    if (provider) {
      console.log('ethereum wallet is connected.')
      window.web3 = new Web3(provider);
    } else {
      console.log('No ethereum wallet detected!!')
    }
  }

  async loadBlockchainData() {
    const web3 = window.web3
    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })
    console.log(this.state.account)

    const networkId = await web3.eth.net.getId()
    const networkData = Nft.networks[networkId]
    console.log(networkId)
    if (networkData) {
      const abi = Nft.abi;
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address)
      console.log(contract)
      this.setState({ contract })
      const totalSupply = await contract.methods.totalSupply().call()
      this.setState({ totalSupply })
      console.log(this.state.contract)

      for (let i = 1; i <= totalSupply; i++) {
        const nft = await contract.methods.allNfts(i - 1).call()
        this.setState({
          nfts: [...this.state.nfts, nft]
        })
      }
      console.log(this.state.nfts)
    } else {
      window.alert('Smart contract not deployed!!')
    }

  }

  mint = (nft) => {
    console.log('new NFT that is being minted that is:', nft)
    console.log('this is new contract:', this.state.contract)
    this.state.contract.methods.mint(nft).send({ from: this.state.account })
    this.setState({
      nfts: [...this.state.nfts, nft]
    })
    console.log("inside the mint function:",this.state.nfts)
  }
  render() {
    return (
      <div>
        <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
          <div className='navbar-brand col-sm-3 col-md-3 mr-0' style={{ color: 'white' }}>
            NFT Minting Machine
          </div>
          <ul className='navbar-nav px-3'>
            <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
              <small className='text-white'>
                {this.state.account}
              </small>
            </li>

          </ul>
        </nav>
        <div className='container-fluid mt-1'>
          <div className='row'>
            <main role='main' className='col-lg-12 d-flex text-center'>
              <div className='content mr-auto ml-auto mt-4' style={{ opacity: '0.8' }}>
                <form onSubmit={(event) => {
                  event.preventDefault()
                  const nftinput = this.nftinput.value
                  this.mint(nftinput)
                }}>
                  <input type='text' placeholder='Enter credit value' className='form-control mb-1' style={{ padding: '1rem', marginTop: '3rem' }}
                    ref={(input) => {
                      this.nftinput = input;
                    }}
                  />
                  <input type='submit'
                    className='btn btn-primary btn-black'
                    value='MINT'
                  />
                </form>
              </div>
            </main>


          </div>

        </div>
      </div>
    )
  }
}
