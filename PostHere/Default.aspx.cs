using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using PostHere.Models;

namespace PostHere
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod]
        public static string GetChatText(long timeStamp)
        {
            var AllPosts = (List<Post>)HttpContext.Current.Application["AllPosts"];
            List<Post> newPosts = AllPosts.Where(x=>x.TimeStamp > timeStamp).ToList();
            

            var jsPosts = JsonConvert.SerializeObject(newPosts);

            return jsPosts;
        }
        [WebMethod]
        public static string GetChatText(int timeStamp)
        {
            var AllPosts = (List<Post>)HttpContext.Current.Application["AllPosts"];
            List<Post> newPosts = AllPosts.Where(x => x.TimeStamp > timeStamp).ToList();


            var jsPosts = JsonConvert.SerializeObject(newPosts);

            return jsPosts;
        }

        [WebMethod]
        public static string GetChatText(string timeStamp)
        {
            var asdf = long.Parse(timeStamp);
            var AllPosts = new List<Post>();
            AllPosts = (List<Post>)HttpContext.Current.Application["AllPosts"];
            if (AllPosts != null)
            {
                IEnumerable<Post> temp = AllPosts.Where(x => x.TimeStamp > asdf);
                List<Post> newPosts;
                if (temp != null || temp.Count() >0)
                {
                    newPosts = temp.ToList();


                    var jsPosts = JsonConvert.SerializeObject(newPosts);
                    return jsPosts;
                }
            }
            return null;
        }
        [WebMethod]
        public static string WriteLine(Post serPost)
        {
            //Post post = JsonConvert.DeserializeObject<Post>(serPost);
            List<Post> AllPosts = (List<Post>)HttpContext.Current.Application["AllPosts"];
            if(AllPosts == null)
                AllPosts = new List<Post>();
            if (!string.IsNullOrEmpty(serPost.PostText))
            {
                AllPosts.Add(serPost);
                HttpContext.Current.Application["AllPosts"] = AllPosts;
            }
            return GetChatText(serPost.LastPostTimeStamp);
        }

        

        private List<Post> CleanupPosts(List<Post> AllPosts, int count)
        {
            List<Post> Cleanedup = new List<Post>();
            for (int i = AllPosts.Count - 1; i < AllPosts.Count; i++)
            {
                Cleanedup.Add(AllPosts[i]);
            }
            return Cleanedup;
        }
    }
}