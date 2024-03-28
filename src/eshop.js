/**
 * Module for the eshop.
 */

"use strict";

module.exports = {
    showCategory: showCategory,
    showProduct: showProduct,
    insertProduct: insertProduct,
    showOneProduct: showOneProduct,
    updateProduct: updateProduct,
    deleteProduct: deleteProduct,
    showCustomer: showCustomer,
    showOrder: showOrder,
    getRowCountProductId: getRowCountProductId,
    showOrderOne: showOrderOne,
    insertOrder: insertOrder,
    showProductOrder: showProductOrder,
    showAvailableProduct: showAvailableProduct,
    insertOrderRow: insertOrderRow,
    insertOrderDetails: insertOrderDetails,
    updateOrder: updateOrder,
    showPicklist: showPicklist,
    shipOrder: shipOrder
};

const mysql  = require("promise-mysql");
const config = require("../config/db/eshop.json");
let db;

(async function() {
    db = await mysql.createConnection(config);

    process.on("exit", () => {
        db.end();
    });
})();

async function showCategory() {
    let sql = `CALL get_category();`;
    let res;

    res = await db.query(sql);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}


async function showProduct() {
    let sql = `CALL get_product_and_its_category();`;
    let res;

    res = await db.query(sql);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function insertProduct(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL insert_product(?, ?, ?);`;

    console.log("AAAAAAAAAAAA", data);
    await db.query(sql, [data.p_id, data.p_name, data.p_price]);
}


async function showOneProduct(id) {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_product_by_id(?);`;
    let res;

    res = await db.query(sql, [id]);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0][0];
}


async function updateProduct(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL update_product(?, ?, ?);`;

    console.log("AAAAAAAAAAAA", data);
    await db.query(sql, [data.p_id, data.name, data.price]);
}


async function deleteProduct(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL delete_product(?);`;

    await db.query(sql, [data.p_id]); //changes
}


//kmom06 ---------------

async function getRowCountProductId() {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_next_product_id();`;
    let res = await db.query(sql);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function showCustomer() {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_customer();`;
    let res = await db.query(sql);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function showOrder(str = "") {
    const db = await mysql.createConnection(config);
    let sql;
    let res;

    if (str == "") {
        sql = `CALL get_order();`;
        res = await db.query(sql);
    } else {
        sql = `CALL get_order_by_str(?);`;
        res = await db.query(sql, [`%${str}%`]);
    }
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function showOrderOne(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL confirm_order(?);`;
    let res = await db.query(sql, [data]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function insertOrder(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL insert_order(?);`;
    let res = await db.query(sql, [data.customer_id]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function showProductOrder(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_product_order(?);`;
    let res = await db.query(sql, [data]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function showAvailableProduct() {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_available_product();`;
    let res = await db.query(sql);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function insertOrderRow(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL insert_order_row(?, ?, ?);`;
    let res = await db.query(sql, [data.order_id, data.product_id, data.quantity]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function insertOrderDetails(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL insert_order_details(?, ?);`;
    let res = await db.query(sql, [data.order_id, data.ordered_quantity]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function updateOrder(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL update_order(?);`;
    let res = await db.query(sql, [data.order_id]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

//CLI.js:

async function showPicklist(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_picklist(?);`;
    let res = await db.query(sql, [data]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function shipOrder(data) {
    const db = await mysql.createConnection(config);
    let sql = `CALL ship_order(?);`;
    let res = await db.query(sql, [data]);

    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}
