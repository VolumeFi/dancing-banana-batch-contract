#!/usr/bin/python3

import pytest

from brownie import web3, accounts, UniswapV3Exchange, Contract

from eth_abi import encode_abi

def test_main(USDC, DAI, WETH, accounts, UniswapV2Router02, MyUniswapV3Exchange, NonfungiblePositionManager, Contract):
    print("NFT Balance")
    print(NonfungiblePositionManager.balanceOf(accounts[0]))
    print("Eth Balance")
    print(accounts[0].balance())
    print("WETH Balance")
    print(WETH.balanceOf(accounts[0]))
    print("DAI Balance")
    print(DAI.balanceOf(accounts[0]))
    print("Contract Balances")
    print(NonfungiblePositionManager.balance())
    print(WETH.balanceOf(MyUniswapV3Exchange))
    print(DAI.balanceOf(MyUniswapV3Exchange))
    UniswapV2Router02.swapETHForExactTokens(10000 * 10 ** 6, [WETH, USDC], accounts[0], 2 ** 256 - 1, {"from":accounts[0], "value": 10 * 10 ** 18})
    USDC.approve(MyUniswapV3Exchange, 10000 * 10 ** 6, {"from":accounts[0]})
    uniV3Params = [DAI, WETH, 3000, -120000, 120000, getSqrtRatioAtTick(-120000), getSqrtRatioAtTick(120000), 0, accounts[0], 2 ** 256 - 1]
    method_id = web3.keccak(b"investTokenForUniPair(uint256,address,uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,address,uint256))")[:4].hex()
    encode_data = encode_abi(['uint256', 'address', 'uint256', 'address', 'address', 'uint256', 'int128', 'int128', 'uint256', 'uint256', 'uint256', 'address', 'uint256'], [0, USDC.address, 1000 * 10 ** 6, DAI.address, WETH.address, 3000, -120000, 120000, getSqrtRatioAtTick(-120000), getSqrtRatioAtTick(120000), 0, accounts[0].address, 2 ** 256 - 1]).hex()
    data = method_id + encode_data
    data += data[2:] + data[2:] + data[2:] + data[2:] + data[2:] + data[2:] + data[2:]

    print("-----STEP1-----")
    MyUniswapV3Exchange.batchRun(data, {"from":accounts[0], "value": 5 * 10 ** 15})
    WETH.deposit({"from": accounts[0], "value": 30 * 10 ** 18})
    UniswapV2Router02.swapETHForExactTokens(30000 * 10 ** 18, [WETH, DAI], accounts[0], 2 ** 256 - 1, {"from":accounts[0], "value": 30 * 10 ** 18})
    WETH.approve(MyUniswapV3Exchange, 30 * 10 ** 18, {"from": accounts[0]})
    DAI.approve(MyUniswapV3Exchange, 30000 * 10 ** 18, {"from": accounts[0]})
    print("NFT Balance")
    print(NonfungiblePositionManager.balanceOf(accounts[0]))
    print("Eth Balance")
    print(accounts[0].balance())
    print("WETH Balance")
    print(WETH.balanceOf(accounts[0]))
    print("DAI Balance")
    print(DAI.balanceOf(accounts[0]))
    print("Contract Balances")
    print(NonfungiblePositionManager.balance())
    print(WETH.balanceOf(MyUniswapV3Exchange))
    print(DAI.balanceOf(MyUniswapV3Exchange))
    method_id = web3.keccak(b"addLiquidityForUniV3(uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,uint256,address,uint256))")[:4].hex()
    encode_data = encode_abi(['uint256', 'address', 'address', 'uint256', 'int128', 'int128', 'uint256', 'uint256', 'uint256', 'uint256', 'address', 'uint256'], [0, DAI.address, WETH.address, 3000, -120000, 120000, 1000 * 10 ** 18, 10 ** 18, 0, 0, accounts[0].address, 2 ** 256 - 1]).hex()
    data = method_id + encode_data
    data += data[2:] + data[2:] + data[2:] + data[2:] + data[2:] + data[2:] + data[2:]

    print("-----STEP2-----")
    MyUniswapV3Exchange.batchRun(data, {"from":accounts[0], "value": 5 * 10 ** 15})
    print("NFT Balance")
    print(NonfungiblePositionManager.balanceOf(accounts[0]))
    print("Eth Balance")
    print(accounts[0].balance())
    print("WETH Balance")
    print(WETH.balanceOf(accounts[0]))
    print("DAI Balance")
    print(DAI.balanceOf(accounts[0]))
    print("Contract Balances")
    print(NonfungiblePositionManager.balance())
    print(WETH.balanceOf(MyUniswapV3Exchange))
    print(DAI.balanceOf(MyUniswapV3Exchange))
    token_id_1 = NonfungiblePositionManager.tokenOfOwnerByIndex(accounts[0], 0)
    method_id = web3.keccak(b"addLiquidityEthForUniV3(uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,uint256,address,uint256))")[:4].hex()
    encode_data = encode_abi(['uint256', 'address', 'address', 'uint256', 'int128', 'int128', 'uint256', 'uint256', 'uint256', 'uint256', 'address', 'uint256'], [0, DAI.address, WETH.address, 3000, -120000, 120000, 1000 * 10 ** 18, 10 ** 18, 0, 0, accounts[0].address, 2 ** 256 - 1]).hex()
    data = method_id + encode_data
    data += data[2:] + data[2:] + data[2:] + data[2:] + data[2:] + data[2:] + data[2:]

    print("-----STEP3-----")
    tx1 = MyUniswapV3Exchange.batchRun(data, {"from":accounts[0], "value": 8 * 10 ** 18 + 5 * 10 ** 15})
    print("NFT Balance")
    print(NonfungiblePositionManager.balanceOf(accounts[0]))
    print("Eth Balance")
    print(accounts[0].balance())
    print("WETH Balance")
    print(WETH.balanceOf(accounts[0]))
    print("DAI Balance")
    print(DAI.balanceOf(accounts[0]))
    print("Contract Balances")
    print(NonfungiblePositionManager.balance())
    print(WETH.balanceOf(MyUniswapV3Exchange))
    print(DAI.balanceOf(MyUniswapV3Exchange))
    liq = tx1.events['IncreaseLiquidity']['liquidity']
    token_id = NonfungiblePositionManager.tokenOfOwnerByIndex(accounts[0], NonfungiblePositionManager.balanceOf(accounts[0]) - 1)
    NonfungiblePositionManager.approve(MyUniswapV3Exchange, token_id, {'from': accounts[0]})
    method_id = web3.keccak(b"addLiquidityEthForUniV3(uint256,(address,address,uint256,int128,int128,uint256,uint256,uint256,uint256,address,uint256))")[:4].hex()
    encode_data = encode_abi(['uint256', 'address', 'address', 'uint256', 'int128', 'int128', 'uint256', 'uint256', 'uint256', 'uint256', 'address', 'uint256'], [0, DAI.address, WETH.address, 3000, -120000, 120000, 1000 * 10 ** 18, 10 ** 18, 0, 0, accounts[0].address, 2 ** 256 - 1]).hex()
    data = method_id + encode_data
    data += data[2:] + data[2:] + data[2:]
    method_id = web3.keccak(b"removeLiquidityEthFromUniV3NFLP(uint256,(uint256,address,uint256))")[:4].hex()
    encode_data = encode_abi(['uint256', 'uint256', 'address', 'uint256'],[token_id, liq // 4, accounts[0].address, 2 ** 256 - 1]).hex()
    data += method_id[2:] + encode_data
    method_id = web3.keccak(b"removeLiquidityFromUniV3NFLP(uint256,(uint256,address,uint256))")[:4].hex()
    encode_data = encode_abi(['uint256', 'uint256', 'address', 'uint256'],[token_id, liq // 4, accounts[0].address, 2 ** 256 - 1]).hex()
    data += method_id[2:] + encode_data
    method_id = web3.keccak(b"divestUniV3NFLPToToken(uint256,address,(uint256,address,uint256),uint256)")[:4].hex()
    encode_data = encode_abi(['uint256', 'address', 'uint256', 'address', 'uint256', 'uint256'],[token_id, "0x0000000000000000000000000000000000000000", liq // 4, accounts[0].address, 2 ** 256 - 1, 1]).hex()
    data += method_id[2:] + encode_data
    method_id = web3.keccak(b"divestUniV3NFLPToToken(uint256,address,(uint256,address,uint256),uint256)")[:4].hex()
    encode_data = encode_abi(['uint256', 'address', 'uint256', 'address', 'uint256', 'uint256'],[token_id, USDC.address, liq // 4, accounts[0].address, 2 ** 256 - 1, 1]).hex()
    data += method_id[2:] + encode_data

    print("-----STEP4-----")
    MyUniswapV3Exchange.batchRun(data, {'from': accounts[0], 'value': 4 * 10 ** 18 + 5 * 10 ** 15})
    print("NFT Balance")
    print(NonfungiblePositionManager.balanceOf(accounts[0]))
    print("Eth Balance")
    print(accounts[0].balance())
    print("WETH Balance")
    print(WETH.balanceOf(accounts[0]))
    print("DAI Balance")
    print(DAI.balanceOf(accounts[0]))
    print("Contract Balances")
    print(NonfungiblePositionManager.balance())
    print(WETH.balanceOf(MyUniswapV3Exchange))
    print(DAI.balanceOf(MyUniswapV3Exchange))

def getSqrtRatioAtTick(tick: int):
    assert tick >= -887272 and tick <= 887272
    absTick = 0
    if tick > 0:
        absTick = tick
    else:
        absTick = -tick

    ratio = 0x100000000000000000000000000000000
    if absTick & 0x1 != 0:
        ratio = 0xfffcb933bd6fad37aa2d162d1a594001
    if absTick & 0x2 != 0:
        ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128
    if absTick & 0x4 != 0:
        ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128
    if absTick & 0x8 != 0:
        ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128
    if absTick & 0x10 != 0:
        ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128
    if absTick & 0x20 != 0:
        ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128
    if absTick & 0x40 != 0:
        ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128
    if absTick & 0x80 != 0:
        ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128
    if absTick & 0x100 != 0:
        ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128
    if absTick & 0x200 != 0:
        ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128
    if absTick & 0x400 != 0:
        ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128
    if absTick & 0x800 != 0:
        ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128
    if absTick & 0x1000 != 0:
        ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128
    if absTick & 0x2000 != 0:
        ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128
    if absTick & 0x4000 != 0:
        ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128
    if absTick & 0x8000 != 0:
        ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128
    if absTick & 0x10000 != 0:
        ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128
    if absTick & 0x20000 != 0:
        ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128
    if absTick & 0x40000 != 0:
        ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128
    if absTick & 0x80000 != 0:
        ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128
    if tick > 0:
        ratio = (1 << 256) // ratio
    
    if ratio % (1 << 32) > 0:
        return (ratio >> 32) + 1
    else:
        return ratio >> 32
