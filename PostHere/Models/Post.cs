using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PostHere.Models
{
    [Serializable]
    public class Post
    {
        public string ScreenName { get; set; }
        public long TimeStamp { get; set; }
        public string PostText { get; set; }
        public long LastPostTimeStamp { get; set; }
    }
}