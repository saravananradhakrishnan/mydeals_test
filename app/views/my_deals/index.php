<link rel="stylesheet" type="text/css" href="public/css/menu.css"></link>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script type="text/javascript" src="public/js/menu.js"></script>

<style>
    .PriceContainer {
        position: absolute;
        z-index: 2;
        top: -24%;
        left: 36%;
        height: 100px;
        overflow: hidden;
        border-radius: 50px;
    }
    .tooltip {
        top: -12%;
        left: auto;
        padding: 10px 10px;
        background: rgba(5, 139, 241, 0.8);
        color: white;
        border-radius: 5px;
        opacity: 0;
        position: absolute;
        -webkit-transition: opacity 0.5s;
        -moz-transition: opacity 0.5s;
        -ms-transition: opacity 0.5s;
        -o-transition: opacity 0.5s;
        transition: opacity 0.5s;
    }
    #hover:hover~.tooltip {
        display: block;
        opacity: 0.6;
    }
    .courseTitle {
        height: 78px;
        float: left;
        margin: 0% 0%;
        width: 100%;
        text-align: left;
        padding: 5px 10px;
        font-size: 14px;
        font-weight: 700;
        background: rgba(5, 139, 241, 0.6);
        ;
    }
    .courseTitle:hover {
        background: rgba(5, 139, 241, 0.8);
    }
    .price {
        position: absolute;
        right: 25px;
        bottom: 35px;
        color: white;
    }
    .price1 {
        color: white;
        font-size: 16px;
    }
    .tought {
        position: absolute;
        left: 25px;
        bottom: 35px;
        color: white;
        font-size: 12px;
        font-weight: normal;
    }
    .tought_list {
        color: white;
        font-size: 12px;
        font-weight: normal;
    }
    .listView ul {
        width: 800px;
        margin-right: 15%;
        margin-left: 15%;
        list-style: none;
        padding: 0px;
    }
    .listView ul li {
        background: rgba(5, 139, 241, 0.6);
        ;
        border-bottom: 1px dotted #CCC;
        margin-bottom: 10px;
        padding-right: 20px;
        height: 140px;
    }
    .listView ul li:hover {
        background: rgba(5, 139, 241, 0.8);
        ;
        border-bottom: 1px dotted #CCC;
        margin-bottom: 10px;
        padding-right: 20px;
        height: 140px;
    }
    .listView ul li .course_image {
        float: left;
        margin-right: 20px;
        width: 23%;
        height: 100%;
    }
    .listView .list .list-left {
        width: 52%;
        float: left;
    }
    .listView .list .list-left .title .c_title {
        color: white;
        float: left;
        margin: 0% 0%;
        width: 100%;
        text-align: left;
        padding: 5px 0px;
        font-size: 18px;
        font-weight: 700;
    }
    .listView .list .list-left .title .description {
        color: white;
        float: left;
        margin: 0% 0%;
        width: 100%;
        text-align: left;
        padding: 5px 0px;
        font-size: 16px;
        font-weight: 300;
    }
    .listView .list .list-right {
        width: 15%;
        float: right;
    }
    .listView .list .list-right .price-list {
        float: right;
        margin: 10% 10%;
    }
    .r {
        float: right;
        background: #f4f4f4;
        padding: 5px 5px 5px 5px;
        border-radius: 6px;
        margin: 1% 1%;
    }
    .showMore {
        text-align: center;
        border: 1px solid grey;
        border-radius: 6px;
        padding: 4px;
        box-shadow: inset 0 0 7px 0 rgba(0,0,0,0.05);
        margin: 0% 22% 2%;
    }
    .btn-default {
        padding: 6px 12px;
        border-radius: 6px;
    }
</style>
<?php include 'config/connection.php'; ?>
<?php include 'header.php'; ?>
<!---sidebar start---->
<div id="menu-toggle" style="margin-top:5%;">
    <img src="public/images/menu/menu.png" width=10 height=10 alt="Menu">&nbsp;<span style="color:#FFF;">Browse Categories</span></img>
</div>
<nav id="menu">


    <?php
    $sql = "SELECT id,name FROM course_categories";
    $result = mysqli_query($con, $sql);
    while ($row = mysqli_fetch_array($result)) {
        $sql1 = "SELECT COUNT(courseEffort) as total,course_id FROM course_spec INNER JOIN course ON course_spec.course_id = course.c_id  WHERE course.courseIsActive='1'";
        //$sql1="SELECT course_title FROM course_spec WHERE courseEffort="+ $row['id'] +"";
        $result1 = mysqli_query($con, $sql1);
        $row1 = mysqli_fetch_array($result1);
        if ($row1['total'] != '0') {
            ?><?php
    }
}
    ?>
    <a href="#" id="link1" onClick="EventHandler1();" name="<?php echo $row['id']; ?>">All<?php echo '(' . $row1['total'] . ')'; ?></a>
    <?php
    $sql = "SELECT id,name FROM course_categories";
    $result = mysqli_query($con, $sql);
    while ($row = mysqli_fetch_array($result)) {
        $sql1 = "SELECT COUNT(courseEffort) as total,course_id FROM course_spec INNER JOIN course ON course_spec.course_id = course.c_id  WHERE course_spec.courseEffort='".$row['id']."' AND course.courseIsActive='1'";
        //$sql1="SELECT course_title FROM course_spec WHERE courseEffort="+ $row['id'] +"";
        $result1 = mysqli_query($con, $sql1);
        $row1 = mysqli_fetch_array($result1);
        if ($row1['total'] != '0') {
            $sql2 = "SELECT courseIsActive FROM course WHERE courseIsActive='1'";
            //$sql1="SELECT course_title FROM course_spec WHERE courseEffort="+ $row['id'] +"";
            $result2 = mysqli_query($con, $sql2);
            $row2 = mysqli_fetch_array($result2);
            ?>

            <a href="#" id="link" name="<?php echo $row['id']; ?>" onClick="EventHandler(this);"><?php
        echo $row['name'];
        echo '(' . $row1['total'] . ')';
            ?></a>


            <?php
        }
    }
    ?>
</nav>

<!---sidebar end---->

<div id="main_container">
    <?php include 'home/slider.php'; ?>	
    <section>
        <div class="container">
            <div class="row">
                <div class="col-sm-9 padding-right" style="width: 100%;min-height: 550px;">
                    <div id="all_result" class="col-sm-9 padding-right" style="width: 100%;">
                        <?php include 'home/allcourse.php'; ?>

                    </div>
                </div>

            </div>
        </div>
    </section>
</div>

<div class="container">
    <div class="row">
        <div class="col-sm-9 padding-right" style="width: 100%;">
            <div id="cat_result" style="border:0px solid #000; width:100%; height:auto; margin-top:5%; display:none;min-height: 550px;">

            </div>
        </div>
    </div>
</div>

<?php include 'footer.php'; ?>


<!----Nav bar script----->

<script>
    function EventHandler(u) {
        { 
            var nav= u.name;

            $("#main_container").hide();
            $(".container").show();
			$('#menu').removeClass('open');
            $('#menu-toggle').removeClass('open');
            var  dataString = 'cat='+nav;
            $.ajax({
                type: "POST",
                url: "catresult.php",
                data: dataString,
                cache: false,
                success: function(html)
                {
                    $("#cat_result").html(html).show();
                }
            });
            return false;  
        }
    }
</script>


<script>
    function EventHandler1() {
        { 
            var nav= '1';

            $("#main_container").hide();
            $(".container").show();
            var  dataString = 'cat='+nav;
            $.ajax({
                type: "POST",
                url: "categoryresult.php",
                data: dataString,
                cache: false,
                success: function(html)
                {
                    $("#cat_result").html(html).show();
                }
            });
            return false;  
        }
    }
</script>

<!----Nav bar script end---->

