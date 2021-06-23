from brownie import UniswapV3Exchange, accounts

def main():
    acct = accounts.load("deployer_account")
    UniswapV3Exchange.deploy({"from":acct})