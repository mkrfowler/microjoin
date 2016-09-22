module Microjoin
  class JoinRespondant
    attr_reader :l, :r, :mode

    def initialize(l,r)
      @l, @r = l, r
    end

    def on(left: nil, right: nil)
      if block_given?
        raise ArgumentError, 'Cannot specify both general and specialized join keys' unless [left, right].compact == []
        left = right = Proc.new
      end

      gl = l.group_by(&left)
      gr = r.group_by(&right)

      send("join_#{mode}", gl, gr)
    end

    [:left, :right, :outer, :inner].each do |mode|
      define_method(mode) { set_mode(mode) }
      define_method("join_#{mode}") { |gl, gr| keyjoin(KEYSET[mode], gl, gr) }
    end

    private

    KEYSET = {
      :left  => -> (gl, gr) { gl.keys },
      :right => -> (gl, gr) { gr.keys },
      :inner => -> (gl, gr) { gl.keys & gr.keys },
      :outer => -> (gl, gr) { gl.keys | gr.keys },
    }

    def keyjoin(keyset, gl, gr)
      keyset::(gl, gr).map { |k|
        vl = gl[k] || []
        vr = gr[k] || []
        [k, [vl, vr]]
      }.to_h
    end

    def set_mode(mode)
      @mode = mode
      self
    end
  end
end
