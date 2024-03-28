/**
 * Routes for the eshop.
 */
"use strict";

const express = require("express");
const eshop   = require("../src/eshop.js"); //used for functions
const router  = express.Router();


router.get("/", (req, res) => {
    res.redirect("eshop/index");  // Redirect to index
}
);

router.get("/eshop/index", (req, res) => {
    let data = {
        title: "Welcome | eShop"
    };

    res.render("eshop/pages/index", data);
}
);

router.get("/eshop/category", async (req, res) => {
    let data = {
        title: "Category | eShop"
    };

    data.res = await eshop.showCategory();
    console.info(data.res);
    res.render("eshop/pages/category", data);
}
);

router.get("/eshop/product", async (req, res) => {
    let data = {
        title: "Product | eShop"
    };

    data.res = await eshop.showProduct();
    console.info(data.res);
    res.render("eshop/pages/product", data);
}
);

router.get("/eshop/about", (req, res) => {
    let data = {
        title: "About | eShop"
    };

    res.render("eshop/pages/about", data);
}
);

router.get("/eshop/create", async (req, res) => {
    let data = {};

    data.title = "Create product | eShop";
    data.two = await eshop.getRowCountProductId();
    console.log(data.two);
    res.render("eshop/pages/create.ejs", data);
}
);

router.post("/create", async (req, res) => {
    await eshop.insertProduct(req.body);
    res.redirect("./product");
});

router.get("/update/:id", async (req, res) => {
    let data = {};

    data.title = "Update product | eShop";
    data.one = await eshop.showOneProduct(req.params.id);
    console.log(data.one);
    res.render("eshop/pages/update.ejs", data);
}
);

router.post("/update", async (req, res) => {
    console.log("UPDATE", req.body);
    await eshop.updateProduct(req.body);

    res.redirect("./product");
}
);

router.get("/delete/:id", async (req, res) => {
    let data = {};

    data.title = "Delete product";
    data.one = await eshop.showOneProduct(req.params.id);
    console.log(data.one);
    res.render("eshop/pages/delete.ejs", data);
}
);
router.post("/delete", async (req, res) => {
    await eshop.deleteProduct(req.body);
    res.redirect("./product");
}
);


//kmom 06 -----------

router.get("/customer", async (req, res) => {
    let data = {};

    data.title = "Customer | eShop";
    data.res = await eshop.showCustomer();
    console.info(data.res);
    res.render("eshop/pages/customer", data);
});

router.get("/order/create", async (req, res) => {
    let data = {};

    data.title = "Order | eShop";
    data.one = await eshop.showOrder();
    console.info(data.one);
    res.render("eshop/pages/order", data);
});

router.get("/order/create/:id", async (req, res) => {
    let data = {};

    data.title = "Order | eShop";
    data.res = await eshop.showOrderOne(req.params.id);
    console.info(data.res);
    data.customer_id = req.params.id;
    res.render("eshop/pages/createorder", data);
});

router.post("/order/create", async (req, res) => {
    await eshop.insertOrder(req.body);
    res.redirect("/eshop/order");
});

router.get("/order", async (req, res) => {
    let data = {};

    data.title = "Order | eShop";
    data.one = await eshop.showOrder();
    console.info(data.res);
    res.render("eshop/pages/order", data);
});


router.post("/order", async (req, res) => {
    await eshop.insertOrderDetails(req.body);
    console.log("FUNKAAAAAAAAAAAAAAAAA 1: ", req.body);

    res.redirect("/eshop/order/show/" + req.body.order_id);
});








router.get("/order/show/:id", async (req, res) => {
    let data = {};
    const orderId = req.params.id;

    data.title = "Order | eShop";
    data.orderId = orderId;
    // data.res = await eshop.showOrderOne(req.params.id);
    data.res = await eshop.showProductOrder(req.params.id);
    console.info("infooooo: ", data.res);


    // console.log("HERE: ", req.params.id);
    // req.cookies["order_id"] = req.params.id;
    // console.log("HERE: ", req.cookies["order_id"]); //debug cookie

    // const orderId = req.cookies["order_id"];
    // console.log("Order ID:", orderId);

    console.log("Order ID:", orderId);


    res.render("eshop/pages/showpicklist", data);
});





router.get("/order_row/create/:id", async (req, res) => {
    let data = {};

    data.title = "Order | eShop";
    data.res = await eshop.showAvailableProduct();
    console.info(data.res);

    data.orderId = req.params.id;

    console.log("Order idddd: " + req.params.id);


    res.render("eshop/pages/createproductorder", data);
});












router.post("/order_row/create", async (req, res) => {
    console.log(req.body);
    console.log("OOOO: ", req.body.order_id);

    await eshop.insertOrderRow(req.body);

    res.redirect("/eshop/order/show/" + req.body.order_id);
});



router.post("/order/show/:id", async (req, res) => {
    console.log("FUNKAAAAAAAAAAAAAAAAA 2: ", req.body);
    await eshop.updateOrder(req.body);
    res.redirect("/eshop/order/send");
});



router.get("/order/send", async (req, res) => {
    let data = {};

    data.title = "Order | eShop";
    // data.res = await eshop.showOrder();
    res.render("eshop/pages/sendorder", data);
});








// router.get("/eshop/order/:id", async (req, res) => {
//     let data = {};
//     data.title = "Order | eShop";
//     data.res = await eshop.showOrder();
//     console.info(data.res);
//     res.render("eshop/pages/order", data);
// });

module.exports = router;
