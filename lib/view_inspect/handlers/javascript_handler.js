(function(){
  var DOM_INSERT_METHOD_NAMES = [
    "appendChild",
    "insertBefore",
    "replaceChild",
  ];

  var fileExcludeList;

  var getStacktrace = function() {
    var e = new Error('dummy');
    var stack = e.stack.replace(/^[^\(]+?[\n$]/gm, '')
        .replace(/^\s+at\s+/gm, '')
        .replace(/^Object.<anonymous>\s*\(/gm, '{anonymous}()@')
        .split('\n');

    stack.splice(0,3); // HACK: we dont want 3 top most callers since they belong to our code
    return stack;
  };

  var isInFileExcludeList = function(caller) {
    var exclude;

    for (var i = 0; i < fileExcludeList.length; i++) {
      exclude = fileExcludeList[i];
      if (caller.indexOf(exclude) !== -1) {
        return true;
      }
    }

    return false;
  };

  var removeUrlParams = function(fileline) {
    var match = fileline.match(/(\?.*):/);

    if (match) {
      match = match.pop();
      fileline = fileline.replace(match, "");
    }

    return fileline;
  };

  var getOrigFileLine = function() {
    var stacktrace = getStacktrace();
    var regex = /(file|http|https)\:\/\/.+?(\/.*:\d+):\d+/;
    var match;
    var fileline = "";

    for (var i = 0; i < stacktrace.length; i++) {
      caller = stacktrace[i];
      if ((match = caller.match(regex)) && !isInFileExcludeList(caller)) {
        fileline = match.pop();
        fileline = removeUrlParams(fileline);
        break;
      }
    }

    return fileline;
  };

  var canSetFileLine = function(node,fileline) {
    return typeof node.setAttribute !== "undefined" &&
          !node.getAttribute("data-orig-file-line") &&
          fileline.length > 0;
  };

  var setFileLineToElement = function(node,fileline) {
    var child;

    if (canSetFileLine(node, fileline)) {
      node.setAttribute("data-orig-file-line", fileline);

      for (var i = 0; i < node.children.length; i++) {
        child = node.children[i];
        setFileLineToElement(child, fileline);
      }
    }
  };

  var setFileLineOnCall = function(methodName) {
    var method = Element.prototype[methodName];

    Element.prototype[methodName] = function(){
      method.apply(this, arguments);
      var node = arguments[0];
      var fileline = getOrigFileLine();
      setFileLineToElement(node, fileline);
      return node;
    };
  };

  var getFileExcluseList = function() {
    var list = document.getElementsByTagName("head")[0].getAttribute("data-orig-exclude-list");
    list = list ? list.split(",") : [];
    return list;
  };

  var enableViewInspect = function() {
    fileExcludeList = getFileExcluseList();
    for (var i = 0; i < DOM_INSERT_METHOD_NAMES.length; i++) {
      var methodName = DOM_INSERT_METHOD_NAMES[i];
      setFileLineOnCall(methodName);
    }
  };

  enableViewInspect();
})();
