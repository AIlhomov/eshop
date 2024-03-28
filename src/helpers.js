/**
 * Helper functions for cli.js
 */
"use strict";

const mysql = require("promise-mysql");
const config = require("../config/db/eshop.json");

async function showLog(data = 0) {
    const db = await mysql.createConnection(config);
    let res;
    let sql;

    if (data === 0) {
        sql = `CALL print_log();`;
        res = await db.query(sql);
    } else {
        sql = `CALL get_log(${data});`;
        res = await db.query(sql, [data.limits]);
    }
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function showProduct() {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_product_and_its_category();`;
    let res;

    res = await db.query(sql);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function showShelf() {
    const db = await mysql.createConnection(config);
    let sql = `CALL get_shelf();`;
    let res;

    res = await db.query(sql);
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function showInv(str = "") {
    const db = await mysql.createConnection(config);
    let sql;
    let res;

    if (str == "") {
        sql = `CALL get_inv();`;
        res = await db.query(sql);
    } else {
        sql = `CALL get_inventory(?);`;
        res = await db.query(sql, [`%${str}%`]);
    }
    console.info(`SQL: ${sql} got ${res.length} rows.`);
    return res[0];
}

async function addInv(data, data1, data2) {
    const db = await mysql.createConnection(config);
    let sql = `CALL insert_inventory(?, ?, ?);`;
    let res = await db.query(sql, [data, data1, data2]);

    return res[0];
}

async function delInv(data, data1, data2) {
    const db = await mysql.createConnection(config);
    let sql = `CALL delete_inventory(?, ?, ?);`;
    let res = await db.query(sql, [data, data1, data2]);

    return res[0];
}


module.exports = {
    showLog: showLog,
    showProduct: showProduct,
    showShelf: showShelf,
    showInv: showInv,
    addInv: addInv,
    delInv: delInv
};
