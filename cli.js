"use strict";

const readline = require('readline-promise').default;
// const helpers = require('./src/helpers.js');
const eshop = require('./src/helpers.js');
const eshop2  = require("./src/eshop.js");

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function exitProgram(exitcode=0) {
    console.log("Exiting program");
    process.exit(exitcode);
}

function showMenu() {
    console.log(`
        Choose something from the menu:
        exit, quit - Exit the program
        menu, help - Show this menu
        about - Shows the members of this eshop
        log <number> - shows the latest rows of log-table
        product - shows the products
        shelf - shows the shelfs table
        inv - shows table of which products exists in stock
        inv <str> - shows table of which products exists in stock with the string
        invadd <productid> <shelf> <number> - puts the new product to the shelf
        invdel <productid> <shelf> <number> - removes the product from the shelf


        kmom06:
        order <search> - shows the orders, <search> is optional and filters the result
        picklist <orderid> - shows the picklist for the order
        ship <orderid> - ships the order

    `);
}


async function main() {
    rl.setPrompt('Eshop: ');
    rl.prompt();

    rl.on("close", exitProgram);

    let res, res1, res2, res3;

    rl.on('line', async function (input) {
        input = input.trim().toLowerCase();
        let parts = input.split(" ");

        switch (parts[0]) {
            case "quit":
            case "exit":
                exitProgram();
                break;
            case "menu":
            case "help":
                showMenu();
                break;
            case "about":
                console.log("This Eshop is made by: Abduvohid Ilhomov and Karam Matar");
                break;
            case "log":
                res = await eshop.showLog(parts[1]);
                console.table(res);
                break;
            case "product":
                res1 = await eshop.showProduct();
                console.table(res1);
                break;
            case "shelf":
                res2 = await eshop.showShelf();
                console.table(res2);
                break;
            case "inv":
                if (parts.length === 1) {
                    res3 = await eshop.showInv();
                } else {
                    res3 = await eshop.showInv(parts[1]);
                }
                console.table(res3);
                break;
            case "invadd":
                await eshop.addInv(parts[1], parts[2], parts[3]);
                console.log("Product added to the shelf");
                break;
            case "invdel":
                await eshop.delInv(parts[1], parts[2], parts[3]);
                break;

            case "order":
                res = await eshop2.showOrder(parts[1]);
                console.table(res);
                break;
            case "picklist":
                res = await eshop2.showPicklist(parts[1]);
                console.table(res);
                break;
            case "ship":
                await eshop2.shipOrder(parts[1]);
                break;

            default:
                console.log("I dont know this command, type 'menu' to seek help.");
                break;
        }
        rl.prompt();
    });
}

main();
