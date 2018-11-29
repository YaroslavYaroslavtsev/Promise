// MIT License
//
// Copyright 2017-18 Electric Imp
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// "Promise" symbol is injected dependency from ImpUnit_Promise module,
// while class being tested can be accessed from global scope as "::Promise".

class ResolveWithPromisesTestCase extends ImpTestCase {

    // Test resolution of Promise with another Promise

    function testResolutionWithPromise() {
        return Promise(function(ok, err) {

            local p = ::Promise(function (resolve1, reject1) {
                resolve1(::Promise(function (resolve2, reject2) {
                    resolve2(::Promise(function (resolve3, reject3) {
                        resolve3("abc");
                    }));
                }));
            });

            p.then(function (res) {
                try {
                    assertEqual("abc", res);
                    ok();
                } catch (e) {
                    err(e);
                }
            }.bindenv(this));

        }.bindenv(this));
    }

    // Test resolution of Promise with another Promise and rejection in the end

    function testResolutionWithPromiseAndRejection() {
        return Promise(function(ok, err) {

            local p = ::Promise(function (resolve1, reject1) {
                resolve1(::Promise(function (resolve2, reject2) {
                    resolve2(::Promise(function (resolve3, reject3) {
                        reject3("abc");
                    }));
                }));
            });

            // when resolving with Promise
            // "then" handlers are not called
            // until resolution of the last
            // Promise in chain happens
            p.then(err);

            p.fail(function (v) {
                try {
                    assertEqual("abc", v);
                    ok();
                } catch (e) {
                    err(e);
                }
            }.bindenv(this));

        }.bindenv(this));
    }
}
