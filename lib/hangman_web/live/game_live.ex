defmodule HangmanWeb.GameLive do
  use HangmanWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, word: [], wrong_steps: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <h1 class="text-red-500 text-5xl font-bold text-center">Tailwind CSS</h1>
      <div class="bg-white p-8 my-16">
        <svg class="hangman mx-auto" width="304" height="288" viewBox="0 0 304 288" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path class="show" d="M2.6344 282.906C2.6344 279.408 1.28915 271.226 3.1173 267.936C4.37491 265.672 4.1746 260.233 6.0147 258.761C10.9279 254.83 10.2844 244.721 15.6727 240.41C17.4703 238.972 19.0863 236.272 20.77 234.401C23.2772 231.615 26.1977 229.832 28.9257 227.104C31.5011 224.528 34.6215 222.481 37.1886 219.914C39.767 217.336 43.3396 216.406 45.8809 214.119C51.6169 208.957 60.8628 209.799 66.431 205.159C69.2631 202.798 75.5975 204.122 78.8791 202.208C82.3188 200.201 86.5191 200.354 90.0395 198.398C97.1886 194.426 106.312 194.675 113.916 192.335C118.42 190.949 124.412 191.154 129.154 191.154C133.283 191.154 137.369 190.189 141.71 190.189C159.85 190.189 178.603 188.863 196.224 192.067C201.672 193.057 207.599 193.27 212.965 194.803C215.409 195.502 219.565 195.923 222.086 195.983C225.419 196.063 228.163 197.794 231.315 197.915C241.466 198.306 249.879 204.007 257.821 209.505C272.391 219.592 278.488 235.477 286.58 249.639C287.791 251.757 291.286 257.626 291.409 259.726C291.59 262.801 294.939 264.789 295.272 267.453C295.641 270.401 297.68 273.353 298.921 276.145C300.274 279.19 300.497 282.731 302.033 285.803" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M146.539 190.189C148.252 181.408 146.618 172.208 148.524 163.629C150.126 156.421 149.436 148.456 149.436 140.933C149.436 133.738 151.368 126.005 151.368 119.202C151.368 110.832 151.368 102.462 151.368 94.0914C151.368 78.3166 151.368 62.5418 151.368 46.7671C151.368 31.5917 154.265 17.7338 154.265 2.82309" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M153.299 3.7889C165.547 1.39912 178.996 2.8231 191.449 2.8231C202.387 2.8231 213.216 3.7889 224.34 3.7889C234.75 3.7889 245.58 4.7547 255.675 4.7547C263.971 4.7547 278.409 2.11765 285.614 5.72051" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M152.334 26.0023C159.808 24.5439 169.477 22.1989 174.547 15.8614C178.587 10.8119 188.744 11.1301 191.932 4.7547" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M284.649 6.68631V27.934" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M299.136 39.5236C296.672 35.3153 292.061 29.8655 286.58 29.8655C282.133 29.8655 275.221 28.2729 272.844 32.763C269.513 39.0565 267.043 55.5723 273.542 60.7712C277.504 63.941 281.607 65.6002 287.063 65.6002C290.998 65.6002 297.204 65.7326 297.204 60.2883C297.204 55.932 300.101 51.231 300.101 46.7671C300.101 41.6336 299.634 36.6262 293.341 36.6262" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M284.649 67.5318C284.649 83.2759 283.683 99.4222 283.683 114.856" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M284.649 114.856C282.104 120.993 278.443 121.648 274.991 125.963C273.482 127.848 271.054 131.311 269.196 132.241" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M282.717 116.788C285.329 120.379 286.608 124.113 289.692 127.197C291.636 129.141 293.162 131.883 294.307 134.172" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M283.683 67.5318C278.178 74.5779 270.955 77.9312 266.298 84.9163" stroke="black" stroke-width="3" stroke-linecap="round"/>
          <path class="show" d="M283.683 68.4976C285.836 71.4584 287.205 74.4875 289.692 76.9752C291.198 78.4808 293.032 79.3495 294.521 80.8384C296.365 82.6821 299.974 85.628 301.067 87.8137" stroke="black" stroke-width="3" stroke-linecap="round"/>
        </svg>
     </div>
    """
  end
end