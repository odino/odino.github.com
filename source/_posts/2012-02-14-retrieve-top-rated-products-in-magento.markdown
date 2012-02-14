---
layout: post
title: "Retrieve top rated products in Magento"
date: 2010-09-11 13:52
comments: true
categories: [PHP, CMS]
alias: "/84/retrieve-top-rated-products-in-magento"
---

Here you learn how to display top rated products using an helper function and a snippet of a `.phtml` block.
<!-- more -->

This is the function you need to put in your helper ( mine is named 'heart', you'll see that later ):

``` php
<?php

public function getTopRatedProducts($limit) { 
 
        $limit = (int) $limit; 
 
        // retrieve all the products
        $products = Mage::getModel('catalog/product')->getCollection(); 
 
        $rated = array(); 
 
        foreach($products as $product) { 
 
            $_product = Mage::getModel('catalog/product')
                        ->load($product->getid()); 

            $storeId    = Mage::app()->getStore()->getId(); 
 
            // retrieve reviews data related to the current products
            // of the iteration
            $summaryData = Mage::getModel('review/review_summary') 
            ->setStoreId($storeId) 
            ->load($_product->getId()); 
 
            // put a subarray containing name, url and rating of the
            // product in our array containing the products
            $rated[] = array(
                         'rating' => $summaryData['rating_summary'], 
                         'name' => $_product->getName(), 
                         'url' => $_product->getUrlPath()
                        ); 
        } 
 
        // tell that the product's array must be ordered by rating DESC
        arsort($rated); 
 
        // return the array with the amount of products defined by $limit
        return array_slice($rated, 0, $limit); 
    }
```

So now that you are able to retrieve the products you need to put them in your Magento pages:

``` php
<?php

//create the array of top rated products calling our function
$products = Mage::helper('heart')->getTopRatedProducts(5);

    foreach($products as $product){

        echo "
            <li>
                <a href='{$product['url']}' />
                    {$product['name']}
                </a>
            </li>
        ";
    }
```

That's it!
