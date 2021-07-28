const ItemManager = artifacts.require("./ItemManager.sol");

contract('ItemManager', accounts => {
  it('should add an item', async () => {
    const itemManagerContract = await ItemManager.deployed();
    const itemName = 'benfica';
    const itemPrice = 100;

    const result = await itemManagerContract.createItem(itemName, itemPrice, { from: accounts[0] });
    assert.equal(result.logs[0].args._itemIndex, 0);

    const item = await itemManagerContract.items(0);
    assert.equal(item.identifier, itemName)
  });
});
