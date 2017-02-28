/**
 * "Promise" symbol is injected dependency from ImpUnit_Promise module,
 * while class being tested can be accessed from global scope as "::Promise".
 */

class Constructor extends ImpTestCase {
    values = [false, 0, "", "tmp", 0.001
        , regexp(@"(\d+) ([a-zA-Z]+)(\p)")
        , null, blob(4), array(5), {
            firstKey = "Max Normal", 
            secondKey = 42, 
            thirdKey = true
        }, function(fff) {
            return fff;
        },  class {
            tmp = 0;
            constructor(){
                tmp = 15;
            }
            
        }, server];

    function testWrongType() {
        local promises = [];
        foreach (value in values) {
            promises.append(
                ::Promise(function(ok, err) {
                    local _value = null;
                    local p = ::Promise(value);
                    p.then(function(res) { 
                        assertTrue(false, "Resolve handler is called");
                    }.bindenv(this), function(res) { 
                        _value = res;
                    }.bindenv(this));
                    p.fail(function(res) { 
                        assertDeepEqual(_value, res, "Fail handler - wrong value, value=" + res);
                    }.bindenv(this));
                    p.finally(function(res) {
                        assertDeepEqual(_value, res, "Finally handler - wrong value, value=" + res);
                    }.bindenv(this));
                    imp.wakeup(0, function() {
                        if (_value == null) {
                            assertTrue(false, "Reject handler is called");
                            err();
                        } else {
                            ok();
                        }
                    }.bindenv(this));
                    }.bindenv(this));
                }.bindenv(this))
            );
        }
        return ::Promise.all(promises);
    }

    function testWrongCount() {
        local promises = [];
        this.assertTrue(true);
        foreach (value in values) {
            try {
                local p = ::Promise(value, value);
                this.assertTrue(false, "Exception is expected. Value="+value);
            } catch(err) {
            }
        }
    }
}
