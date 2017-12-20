{% extends 'LGD:page/layout.tpl' %}

{% block content %}
    {% require "LGD:static/css/uploadzip.less" %}
    <div class="main-container ace-save-state" id="main-container">
      <div class="main-content">
        <div class="main-content-inner">
          <div class="page-content">
            <div class="page-header">
              <form action="/uploadzip" enctype="multipart/form-data" method="POST" id="amp-myform">
                <input type="file" accept="application/x-zip-compressed" name="image[]" value="上传" multiple="multiple" class="inp" style="width:180px;">
                <input  type="submit" value="提交" id="amp-myaction">
              </form>
            </div>
            <div class="row">
              <div class="col-xs-12">
                <div class="row">
                  <div class="col-xs-12">
                    <div>
                      <table  class="table  table-bordered table-hover">
                        <thead>
                          <tr>
                            <th>点击查看</th>
                            <th>点击下载</th>
                            <th>上传时间</th>
                            <th>文件名称</th>
                          </tr>
                        </thead>
                        <tbody id="tbody-pagination">
                          
                        </tbody>
                      </table>
                      <nav aria-label="Page navigation">
                        <ul class="pager">
                          <li  id="page-pre">
                            <a href="#" aria-label="Previous">
                              <span aria-hidden="true">&laquo;</span>
                            </a>
                          </li>
                          <li class="page-num select"><a>1</a></li>
                          <li class="page-num"><a>2</a></li>
                          <li class="page-num"><a>3</a></li>
                          <li class="page-num"><a>4</a></li>
                          <li class="page-num"><a>5</a></li>
                          <li id="page-next">
                            <a href="#" aria-label="Next">
                              <span aria-hidden="true">&raquo;</span>
                            </a>
                          </li>
                        </ul>
                      </nav>
                    </div>
                  </div><!-- /.span -->
                </div><!-- /.row -->
                <!-- PAGE CONTENT ENDS -->
              </div><!-- /.col -->
            </div><!-- /.row -->
          </div><!-- /.page-content -->
        </div>
      </div><!-- /.main-content -->

      <script type="text/html" id="template">
            <tr>
                <td><a href="<%= viewurl %>" target="_blank">点击查看</a></td>
                <td><a href="<%= zip_src %>">点击下载</a></td>
                <td> <%=dateFormat(upload_date, 'yyyy-MM-dd hh:mm:ss')%></td> 
                <td><%= originalname %></td>
            </tr>
        </script>
      {% script %}
        $(function(){

          var pagComp = (function(){
            var pagComp = {
              pageIdx: 1,
              totalNum: 10,
              flagNum: 3,//保存上一次点击的分页数字
              init: function(){
                var _this = this;
                this.loadData();
                $("#page-next").on('click', function(){
                  _this.pageIdx++;
                  if(_this.pageIdx <= 10){
                    _this.pageHandle(_this.pageIdx);
                  }else{
                    _this.pageIdx = 10;
                  }
                });
                $("#page-pre").on('click', function(){
                  _this.pageIdx--;
                  if(_this.pageIdx >= 1){
                    _this.pageHandle(_this.pageIdx);
                  }else{
                    _this.pageIdx = 1;
                  }
                });
                $(".page-num").on('click', function(){
                  _this.pageHandle($(this).children('a').html());
                });
              },
              pageHandle: function(num){
                var _this = this;
                var $htmlNum = num;
                if( parseInt($htmlNum)>=3 &&  parseInt($htmlNum) < _this.totalNum -1){
                  $(".page-num").each(function(){
                    $(this).removeClass("select");
                    $(this).children('a').html($htmlNum - _this.flagNum + parseInt($(this).children('a').html()));
                  });
                  $(".page-num").eq(2).addClass("select");
                  _this.flagNum = $htmlNum;
                }else{
                  $(".page-num").each(function(i, v){
                    $(this).removeClass("select");
                  });
                  $(".page-num").eq(parseInt($htmlNum)%5 - 1).addClass('select');
                } 
                _this.pageIdx = $htmlNum;
                _this.loadData($htmlNum);
              },
              loadData: function(pageNum){
                var _this = this;
                var tbodyPage = $("#tbody-pagination");
                var options = {
                  pageIdx: pageNum || this.pageIdx
                };
                $.get('/uploadzip', options, function(data){
                  tbodyPage.html('');
                  var tpl = document.getElementById('template').innerHTML;
                  for(var i=0, len=data.data.length; i<len; i++){
                    var sHtml = template(tpl, data.data[i]);
                    sHtml = sHtml.trim();
                    sHtml = sHtml.replace(/>\s+</g, "><");
                    tbodyPage.append($(sHtml));
                  }
                  _this.totalNum = data.totalNum;
                });
              }
            }
            return pagComp;
          })();
          pagComp.init();
        });

        //添加时间过滤器
        template.registerFunction('dateFormat', function (date, format) {
            date = new Date(date);
            var map = {
                "M": date.getMonth() + 1, //月份 
                "d": date.getDate(), //日 
                "h": date.getHours(), //小时 
                "m": date.getMinutes(), //分 
                "s": date.getSeconds(), //秒 
                "q": Math.floor((date.getMonth() + 3) / 3), //季度 
                "S": date.getMilliseconds() //毫秒 
            };
            format = format.replace(/([yMdhmsqS])+/g, function(all, t){
                var v = map[t];
                if(v !== undefined){
                    if(all.length > 1){
                        v = '0' + v;
                        v = v.substr(v.length-2);
                    }
                    return v;
                }
                else if(t === 'y'){
                    return (date.getFullYear() + '').substr(4 - all.length);
                }
                return all;
            });
            return format;
        });
      {% endscript %}
      
{% endblock %}