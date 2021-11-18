class RTCIceCandidate {
  RTCIceCandidate(this.candidate, this.sdpMid, this.sdpMlineIndex);
  final String? candidate;
  final String? sdpMid;
  final int? sdpMlineIndex;
  dynamic ToMap() {
    return {
      'candidate': candidate,
      'sdpMid': sdpMid,
      'sdpMLineIndex' : sdpMlineIndex
    };
  }

}