// Copyright (c) 2016 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

// "Promise" symbol is injected dependency from ImpUnit_Promise module,
// while class being tested can be accessed from global scope as "::Promise".

class BasicTestCase extends ImpTestCase {

    // Test rejection with throw+fail() handler

    function testCatchWithThenHandler1() {
        return Promise(function(ok, err) {
            local p = ::Promise(function (resolve, reject) {
                throw "Error in Promise";
            });

            p.then(err, @(res) ok());
        }.bindenv(this));
    }

    // Test rejection with reject()+fail() handler

    function testCatchWithThenHandler2() {
        return Promise(function(ok, err) {
            local p = ::Promise(function (resolve, reject) {
                reject();
            });
            p.then(err, ok);
        }.bindenv(this));
    }

    // Test rejection with throw+fail() handler

    function testCatchWithFailHandler1() {
        return Promise(function(ok, err) {
            local p = ::Promise(function (resolve, reject) {
                throw "Error in Promise";
            });
            p.then(err).fail(@(res) ok());
        }.bindenv(this));
    }

    // Test rejection with reject()+fail() handler

    function testCatchWithFailHandler2() {
        return Promise(function(ok, err) {
            local p = ::Promise(function (resolve, reject) {
                reject();
            });
            p.then(err).fail(ok);
        }.bindenv(this));
    }

    // Test that finally() is called on rejection

    function testFinallyCallOnRejection() {
        return Promise(function(ok, err) {

            local thenCalled = false;
            local failCalled = false;

            local p = ::Promise(function (resolve, reject) {
                reject();
            });

            p
                .then(function (v) { thenCalled = true; })
                .fail(function (v) { failCalled = true; })
                .finally(function (v) {
                    try {
                        this.assertEqual(false, thenCalled);
                        this.assertEqual(true, failCalled);
                        ok();
                    } catch (e) {
                        err(e);
                    }
                }.bindenv(this));


        }.bindenv(this));
    }

    // Test that finally() is called on resolution

    function testFinallyCallOnResolution() {
        return Promise(function(ok, err) {

            local thenCalled = false;
            local failCalled = false;

            local p = ::Promise(function (resolve, reject) {
                resolve();
            });

            p
                .then(function (v) { thenCalled = true; })
                .fail(function (v) { failCalled = true; })
                .finally(function (v) {
                    try {
                        this.assertEqual(true, thenCalled);
                        this.assertEqual(false, failCalled);
                        ok();
                    } catch (e) {
                        err(e);
                    }
                }.bindenv(this));

        }.bindenv(this));
    }

    // Test that finally() is called on resolution

    function testFinallyCallOnResolution() {
        return Promise(function(ok, err) {
            local p = ::Promise(function (resolve, reject) {resolve();});
            p.finally(ok);
        }.bindenv(this));
    }


    // Test that finally() is called on rejection

    function testFinallyCallOnResolution() {
        return Promise(function(ok, err) {
            local p = ::Promise(function (resolve, reject) {reject();});
            p.finally(ok);
        }.bindenv(this));
    }

    function testHandlerInstances() {
        return Promise(function(ok, err) {
            local p1 = ::Promise(function (resolve, reject) {
            });

            p1.then(function (v) {
                err("p1 handlers should not be called");
            });

            local p2 = ::Promise(function (resolve, reject) {
                imp.wakeup(0.5, function() {
                    resolve();
                });
            });

            p2.then(function (v) {
            });

            p2.then(function (v) {
                ok();
            });

        }.bindenv(this));
    }
}
